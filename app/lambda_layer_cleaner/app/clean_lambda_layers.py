"""Delete Lambda layer versions that nothing uses and Terraform does not manage.

Layer versions cannot be tagged, so "managed" means the version ARNs the deploying
stack passes in. A version is deleted only if all of these hold:

- its layer is not in the exclusion list (layers other states or tools manage);
- it is not one of the managed version ARNs;
- it is not the latest version of its layer, nor newer than the latest `ListLayers`
  reported (a version published mid-run, such as by a concurrent apply, is not yet
  in the managed set);
- no version of any function in this account and region references it;
- its policy grants no principal other than this account (another account's use is
  invisible here).

With DRY_RUN (the default) it only logs what it would delete.
"""

import collections
import dataclasses
import enum
import json
import logging
import os
import typing

import boto3
import botocore.exceptions

if typing.TYPE_CHECKING:
    from mypy_boto3_lambda import LambdaClient

logger = logging.getLogger("lambda-layer-cleaner")
logger.setLevel(logging.INFO)


class KeepReason(enum.StrEnum):
    EXCLUDED = "excluded"
    MANAGED = "managed"
    LATEST = "latest"
    IN_USE = "in_use"
    SHARED = "shared"


@dataclasses.dataclass(frozen=True)
class CleanerConfig:
    account_id: str
    dry_run: bool
    excluded_layer_arn_set: frozenset[str]
    managed_layer_version_arn_set: frozenset[str]


@dataclasses.dataclass(frozen=True)
class LayerVersionFacts:
    layer_arn: str
    latest_version_number: int
    shared: bool
    version_arn: str
    version_number: int


@dataclasses.dataclass
class CleanupSummary:
    dry_run: bool
    deleted_list: list[str] = dataclasses.field(default_factory=list[str])
    error_list: list[str] = dataclasses.field(default_factory=list[str])
    kept_by_reason: collections.Counter[str] = dataclasses.field(
        default_factory=collections.Counter[str]
    )
    versions_seen: int = 0

    def as_dict(self) -> dict[str, typing.Any]:
        return {
            "deleted_count": len(self.deleted_list),
            "deleted_list": self.deleted_list,
            "dry_run": self.dry_run,
            "error_list": self.error_list,
            "kept_by_reason": dict(sorted(self.kept_by_reason.items())),
            "versions_seen": self.versions_seen,
        }


def keep_reason(
    config: CleanerConfig,
    facts: LayerVersionFacts,
    used_version_arn_set: frozenset[str],
) -> KeepReason | None:
    """Why a version must be kept, or None if it may be deleted"""
    if facts.layer_arn in config.excluded_layer_arn_set:
        return KeepReason.EXCLUDED
    if facts.version_arn in config.managed_layer_version_arn_set:
        return KeepReason.MANAGED
    # At or above the ListLayers snapshot's latest: the latest, or published since
    if facts.version_number >= facts.latest_version_number:
        return KeepReason.LATEST
    if facts.version_arn in used_version_arn_set:
        return KeepReason.IN_USE
    if facts.shared:
        return KeepReason.SHARED
    return None


def _principal_list(statement: dict[str, typing.Any]) -> list[str]:
    principal = statement.get("Principal")
    if principal is None:
        return []
    if isinstance(principal, str):
        return [principal]
    value_list: list[str] = []
    for value in typing.cast(dict[str, typing.Any], principal).values():
        if isinstance(value, str):
            value_list.append(value)
        else:
            value_list.extend(typing.cast(list[str], value))
    return value_list


def is_own_account_principal(principal: str, account_id: str) -> bool:
    return principal in (account_id, f"arn:aws:iam::{account_id}:root") or (
        principal.startswith("arn:") and principal.endswith(f"::{account_id}:root")
    )


def policy_is_shared(policy_json: str | None, account_id: str) -> bool:
    """True if a layer version policy allows any principal but this account"""
    if not policy_json:
        return False
    policy = typing.cast(dict[str, typing.Any], json.loads(policy_json))
    statement_raw = policy.get("Statement", [])
    statement_list = typing.cast(
        list[dict[str, typing.Any]],
        [statement_raw] if isinstance(statement_raw, dict) else statement_raw,
    )
    for statement in statement_list:
        if statement.get("Effect") != "Allow":
            continue
        if any(
            not is_own_account_principal(principal, account_id)
            for principal in _principal_list(statement)
        ):
            return True
    return False


def load_config(environ: typing.Mapping[str, str]) -> CleanerConfig:
    return CleanerConfig(
        account_id=environ["ACCOUNT_ID"],
        # Anything but an explicit false keeps the safe default
        dry_run=environ.get("DRY_RUN", "true").strip().lower() != "false",
        excluded_layer_arn_set=frozenset(
            json.loads(environ.get("EXCLUDED_LAYER_ARN_LIST", "[]"))
        ),
        managed_layer_version_arn_set=frozenset(
            json.loads(environ.get("MANAGED_LAYER_VERSION_ARN_LIST", "[]"))
        ),
    )


def used_layer_version_arn_set(lambda_client: "LambdaClient") -> frozenset[str]:
    """Layer version ARNs referenced by any version of any function"""
    used: set[str] = set()
    paginator = lambda_client.get_paginator("list_functions")
    for page in paginator.paginate(FunctionVersion="ALL"):
        for function in page.get("Functions", []):
            for layer in function.get("Layers", []):
                if "Arn" in layer:
                    used.add(layer["Arn"])
    return frozenset(used)


def get_policy_json(
    lambda_client: "LambdaClient", layer_arn: str, version_number: int
) -> str | None:
    try:
        response = lambda_client.get_layer_version_policy(
            LayerName=layer_arn, VersionNumber=version_number
        )
    except lambda_client.exceptions.ResourceNotFoundException:
        return None  # No policy: not shared
    return response.get("Policy")


def clean_layer(
    lambda_client: "LambdaClient",
    config: CleanerConfig,
    summary: CleanupSummary,
    used_version_arn_set: frozenset[str],
    layer_arn: str,
    latest_version_number: int,
) -> None:
    paginator = lambda_client.get_paginator("list_layer_versions")
    for page in paginator.paginate(LayerName=layer_arn):
        for version in page.get("LayerVersions", []):
            version_arn = version.get("LayerVersionArn")
            version_number = version.get("Version")
            if version_arn is None or version_number is None:
                continue  # The API always returns both; never act on a partial entry
            summary.versions_seen += 1
            facts = LayerVersionFacts(
                layer_arn=layer_arn,
                latest_version_number=latest_version_number,
                shared=False,
                version_arn=version_arn,
                version_number=version_number,
            )
            reason = keep_reason(config, facts, used_version_arn_set)
            if reason is None:
                # Only fetch the policy for versions every other guard would delete
                shared = policy_is_shared(
                    get_policy_json(lambda_client, layer_arn, version_number),
                    config.account_id,
                )
                facts = dataclasses.replace(facts, shared=shared)
                reason = keep_reason(config, facts, used_version_arn_set)
            if reason is not None:
                summary.kept_by_reason[reason] += 1
                continue
            if config.dry_run:
                logger.info(f"Would delete {version_arn} (dry run)")
            else:
                logger.info(f"Deleting {version_arn}")
                lambda_client.delete_layer_version(
                    LayerName=layer_arn, VersionNumber=version_number
                )
            summary.deleted_list.append(version_arn)


def clean_layers(
    lambda_client: "LambdaClient", config: CleanerConfig
) -> CleanupSummary:
    summary = CleanupSummary(dry_run=config.dry_run)
    # Without the full list of used versions nothing can be judged safely, so this raises
    used_version_arn_set = used_layer_version_arn_set(lambda_client)
    paginator = lambda_client.get_paginator("list_layers")
    for page in paginator.paginate():
        for layer in page.get("Layers", []):
            layer_arn = layer.get("LayerArn")
            latest_version_number = layer.get("LatestMatchingVersion", {}).get(
                "Version"
            )
            if layer_arn is None or latest_version_number is None:
                continue  # Without the latest version nothing can be judged safely
            try:
                clean_layer(
                    lambda_client=lambda_client,
                    config=config,
                    summary=summary,
                    used_version_arn_set=used_version_arn_set,
                    layer_arn=layer_arn,
                    latest_version_number=latest_version_number,
                )
            except (botocore.exceptions.BotoCoreError, botocore.exceptions.ClientError):
                logger.exception(f"Failed to clean layer {layer_arn}")
                summary.error_list.append(layer_arn)
    return summary


def lambda_handler(
    event: dict[str, typing.Any],
    context: typing.Any,
) -> dict[str, typing.Any]:
    config = load_config(os.environ)
    excluded = sorted(config.excluded_layer_arn_set)
    managed = sorted(config.managed_layer_version_arn_set)
    logger.info(
        f"Cleaning layers: dry_run={config.dry_run}, excluded={excluded}, managed={managed}"
    )
    summary = clean_layers(boto3.client("lambda"), config)
    result = summary.as_dict()
    logger.info(f"Summary: {json.dumps(result)}")
    if summary.error_list:
        # Fail the invocation so the function's error alarm fires
        raise RuntimeError(f"Failed to clean layers: {summary.error_list}")
    return result


if __name__ == "__main__":
    logging.basicConfig()
    print(json.dumps(lambda_handler({}, None), indent=2))
