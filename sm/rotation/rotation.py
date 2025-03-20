"""# noqa: E501
Lambda handler for rotating an AWS SecretsManager secrets
See https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRotationTemplate/lambda_function.py
"""

import json
import logging
import os
import typing

import boto3

LOGGING_LEVEL = os.environ.get("LOGGING_LEVEL", "INFO")
RANDOM_STRING_CHARACTERS_TO_EXCLUDE = os.environ.get(
    "RANDOM_STRING_CHARACTERS_TO_EXCLUDE", ""
)
RANDOM_STRING_LENGTH = os.environ.get("RANDOM_STRING_LENGTH", "")
ROTATION_KEY_TO_REPLACE = os.environ.get("ROTATION_KEY_TO_REPLACE", "")
ROTATION_LIST_MAX_LENGTH = os.environ.get("ROTATION_LIST_MAX_LENGTH", "")
ROTATION_METHOD = os.environ.get("ROTATION_METHOD", "")

logging.basicConfig(
    format="%(asctime)s %(levelname)-8s %(message)s",
    level=LOGGING_LEVEL,
)
logger = logging.getLogger()


def log_and_raise(
    msg: str,
) -> typing.NoReturn:
    logger.error(msg)
    raise ValueError(msg)


def rotate_whole_string(
    secret_id: str,
    current_secret_string: str,
    new_random_string: str,
) -> str:
    return new_random_string


def load_and_validate_secret_key_value(
    secret_id: str,
    current_secret_string: str,
) -> dict[typing.Any, typing.Any]:
    secret_dict = json.loads(current_secret_string)
    if not isinstance(secret_dict, dict):
        log_and_raise(f"Secret {secret_id} does not support key-value replacement")
    # dict[Unknown, Unknown] != dict[typing.Any, typing.Any] so appease type checker
    secret_dict = typing.cast(dict[typing.Any, typing.Any], secret_dict)
    if ROTATION_KEY_TO_REPLACE not in secret_dict:
        log_and_raise(
            f"Secret {secret_id} does not include {ROTATION_KEY_TO_REPLACE} in key set {secret_dict.keys()}"
        )
    return secret_dict


def rotate_key_value(
    secret_id: str,
    current_secret_string: str,
    new_random_string: str,
) -> str:
    secret_dict = load_and_validate_secret_key_value(
        secret_id=secret_id,
        current_secret_string=current_secret_string,
    )
    secret_dict[ROTATION_KEY_TO_REPLACE] = new_random_string
    new_secret_string = json.dumps(secret_dict)
    return new_secret_string


def rotate_key_value_list(
    secret_id: str,
    current_secret_string: str,
    new_random_string: str,
) -> str:
    secret_dict = load_and_validate_secret_key_value(
        secret_id=secret_id,
        current_secret_string=current_secret_string,
    )
    if not isinstance(secret_dict[ROTATION_KEY_TO_REPLACE], list):
        log_and_raise(
            f"Secret {secret_id} key {ROTATION_KEY_TO_REPLACE} is not a list that can be rotated"
        )
    max_len = int(ROTATION_LIST_MAX_LENGTH)
    secret_dict[ROTATION_KEY_TO_REPLACE] = secret_dict[ROTATION_KEY_TO_REPLACE][
        0 : max_len - 1
    ]
    secret_dict[ROTATION_KEY_TO_REPLACE].insert(0, new_random_string)
    new_secret_string = json.dumps(secret_dict)
    return new_secret_string


class RotationFunction(typing.Protocol):
    def __call__(
        self,
        secret_id: str,
        current_secret_string: str,
        new_random_string: str,
    ) -> str: ...


ROTATION_METHOD_TO_ROTATION_CALL: dict[str, RotationFunction] = {
    "ROTATE_WHOLE_STRING": rotate_whole_string,
    "ROTATE_KEY_VALUE": rotate_key_value,
    "ROTATE_KEY_VALUE_LIST_NEWEST_FIRST": rotate_key_value_list,
}


def validate_var_is_int(
    name: str,
) -> None:
    value = os.environ.get(name, "")
    try:
        int(value)
    except Exception:
        log_and_raise(f"Environment variable {name} must be an integer, got {value}")


def validate_env() -> None:
    if ROTATION_METHOD not in ROTATION_METHOD_TO_ROTATION_CALL:
        log_and_raise(
            "Environment must define ROTATION_METHOD as one of {}, got '{}'".format(
                ROTATION_METHOD_TO_ROTATION_CALL.keys(),
                ROTATION_METHOD,
            )
        )
    if "KEY" in ROTATION_METHOD and not ROTATION_KEY_TO_REPLACE:
        log_and_raise(
            f"Environment must define ROTATION_KEY_TO_REPLACE when using method {ROTATION_METHOD}"
        )
    if ROTATION_METHOD == "ROTATE_KEY_VALUE_LIST":
        if not ROTATION_LIST_MAX_LENGTH:
            log_and_raise(
                f"Environment must define ROTATION_LIST_MAX_LENGTH when using method {ROTATION_METHOD}"
            )
        validate_var_is_int("ROTATION_LIST_MAX_LENGTH")
    if RANDOM_STRING_LENGTH:
        validate_var_is_int("RANDOM_STRING_LENGTH")


# Do this at import time to catch errors before we start rotating
validate_env()


def lambda_handler(
    event: dict[str, typing.Any],
    context: dict[str, typing.Any],
) -> None:
    service_client = boto3.client("secretsmanager")
    validate_version_is_staged_correctly(
        service_client=service_client,
        secret_id=event["SecretId"],
        new_version_token=event["ClientRequestToken"],
    )
    dispatch_version_rotation_step(
        step=event["Step"],
        service_client=service_client,
        secret_id=event["SecretId"],
        new_version_token=event["ClientRequestToken"],
    )


def validate_version_is_staged_correctly(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
) -> None:
    metadata = service_client.describe_secret(SecretId=secret_id)
    if not metadata["RotationEnabled"]:
        log_and_raise(f"Secret {secret_id} is not enabled for rotation")
    versions = metadata["VersionIdsToStages"]
    if new_version_token not in versions:
        log_and_raise(
            f"Secret version {new_version_token} has no stage for rotation of secret {secret_id}."
        )
    if "AWSCURRENT" in versions[new_version_token]:
        logger.info(
            f"Secret version {new_version_token} already set as AWSCURRENT for secret {secret_id}."
        )
        return
    elif "AWSPENDING" not in versions[new_version_token]:
        log_and_raise(
            f"Secret version {new_version_token} not set as AWSPENDING for rotation of secret {secret_id}."
        )


def dispatch_version_rotation_step(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
    step: str,
) -> None:
    call: typing.Callable[[typing.Any, str, str], None]
    if step == "createSecret":
        call = create_secret
    elif step == "setSecret":
        call = set_secret
    elif step == "testSecret":
        call = test_secret
    elif step == "finishSecret":
        call = finish_secret
    else:
        raise ValueError(f"Invalid step parameter {step}")
    call(
        service_client=service_client,
        secret_id=secret_id,
        new_version_token=new_version_token,
    )


def create_secret(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
) -> None:
    """Create a pending secret version"""
    # Make sure the current secret exists
    current_secret = service_client.get_secret_value(
        SecretId=secret_id,
        VersionStage="AWSCURRENT",
    )

    # Now try to get the secret version, if that fails, put a new secret
    try:
        service_client.get_secret_value(
            SecretId=secret_id,
            VersionId=new_version_token,
            VersionStage="AWSPENDING",
        )
        logger.info(f"createSecret: Successfully retrieved secret {secret_id}.")
    except service_client.exceptions.ResourceNotFoundException:
        new_random_password = service_client.get_random_password(
            PasswordLength=int(RANDOM_STRING_LENGTH) if RANDOM_STRING_LENGTH else None,
            ExcludeCharacters=RANDOM_STRING_CHARACTERS_TO_EXCLUDE,
        )
        rotation_call = ROTATION_METHOD_TO_ROTATION_CALL[ROTATION_METHOD]
        new_secret_string = rotation_call(
            secret_id=secret_id,
            current_secret_string=current_secret["SecretString"],
            new_random_string=new_random_password["RandomPassword"],
        )
        service_client.put_secret_value(
            SecretId=secret_id,
            ClientRequestToken=new_version_token,
            SecretString=new_secret_string,
            VersionStages=["AWSPENDING"],
        )
        logger.info(
            f"createSecret: Successfully put secret {secret_id} and version {new_version_token}."
        )


def set_secret(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
) -> None:
    """Set the pending secret version in the external service, e.g. update the password"""
    pass


def test_secret(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
) -> None:
    """Test the pending secret version in the external service, e.g. login using the password"""
    pass


def finish_secret(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
) -> None:
    """Set the pending secret version to the current version"""
    metadata = service_client.describe_secret(SecretId=secret_id)
    for current_version_token in metadata["VersionIdsToStages"]:
        if "AWSCURRENT" in metadata["VersionIdsToStages"][current_version_token]:
            finish_secret_idempotently(
                service_client=service_client,
                secret_id=secret_id,
                new_version_token=new_version_token,
                current_version_token=current_version_token,
            )
            break


def finish_secret_idempotently(
    service_client: typing.Any,
    secret_id: str,
    new_version_token: str,
    current_version_token: str,
) -> None:
    if new_version_token == current_version_token:
        logger.info(
            f"finishSecret: Version {new_version_token} already marked as AWSCURRENT for {secret_id}"
        )
        return
    service_client.update_secret_version_stage(
        SecretId=secret_id,
        VersionStage="AWSCURRENT",
        MoveToVersionId=new_version_token,
        RemoveFromVersionId=current_version_token,
    )
    logger.info(
        f"finishSecret: Successfully set AWSCURRENT stage to version {new_version_token} for secret {secret_id}."
    )
