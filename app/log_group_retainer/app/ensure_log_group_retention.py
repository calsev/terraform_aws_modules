import json
import logging
import os
import re
import typing

import boto3

logger = logging.getLogger("ri-purchaser")
logger.setLevel(logging.INFO)

RETENTION_STR = os.environ.get(
    "RETENTION_LIST",
    '${retention_list}',  # fmt: skip
)
RETENTION_LIST_RAW = json.loads(RETENTION_STR)


def compile_patterns(retention: dict[str, typing.Any]) -> dict[str, typing.Any]:
    return {
        **retention,
        "match_regex_list": [re.compile(r) for r in retention["match_regex_list"]],
    }


RETENTION_LIST = [compile_patterns(r) for r in RETENTION_LIST_RAW]


def get_all_log_groups(
    log_client: typing.Any,
) -> typing.Generator[typing.Any, None, None]:
    paginator = log_client.get_paginator("describe_log_groups")
    for page in paginator.paginate():
        for group in page.get("logGroups", []):
            yield group


def new_retention_for_log_group(
    default_retention: int,
    max_retention: int,
    min_rentention: int,
    current_retention: int | None,
) -> int | None:
    if current_retention is None:
        # No retention set
        return default_retention
    elif current_retention < min_rentention:
        return min_rentention
    elif current_retention > max_retention:
        return max_retention
    else:
        # No change needed
        return None


def adjust_retention_for_log_group(
    log_client: typing.Any,
    log_group_name: str,
    current_retention: int | None,
) -> None:
    for retention in RETENTION_LIST:
        if any(
            log_group_name.startswith(prefix)
            for prefix in retention["match_prefix_list"]
        ) or any(
            re.search(regex, log_group_name) for regex in retention["match_regex_list"]
        ):
            new_retention = new_retention_for_log_group(
                default_retention=retention["default_days"],
                max_retention=retention["max_days"],
                min_rentention=retention["min_days"],
                current_retention=current_retention,
            )
            if new_retention is not None:
                logger.info(
                    f"Updating retention for group {log_group_name}: {current_retention} -> {new_retention}"
                )
                log_client.put_retention_policy(
                    logGroupName=log_group_name, retentionInDays=new_retention
                )
            return
    raise ValueError(f"No match found for group {log_group_name}")


def ensure_log_group_retention_for_account():
    logger.info(f"Retention is {RETENTION_LIST}")
    log_client = typing.cast(typing.Any, boto3.client("logs"))
    for log_group in get_all_log_groups(log_client):
        log_group_name = log_group["logGroupName"]
        logger.info(f"Checking retention for group {log_group_name}")
        current_retention = typing.cast(
            int | None, log_group.get("retentionInDays")  # May be missing
        )
        adjust_retention_for_log_group(
            log_client=log_client,
            log_group_name=log_group_name,
            current_retention=current_retention,
        )


def lambda_handler(
    event: dict[str, typing.Any],
    context: dict[str, typing.Any],
) -> dict[str, typing.Any]:
    logger.info("Lambda handler started")
    ensure_log_group_retention_for_account()
    return {
        "statusCode": 200,
        "body": json.dumps({"success": True}),
    }


if __name__ == "__main__":
    ensure_log_group_retention_for_account()
