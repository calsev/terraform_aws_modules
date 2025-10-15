import json
import logging
import os
import typing

import boto3

logger = logging.getLogger("ri-purchaser")
logger.setLevel(logging.INFO)

DEFAULT_METRIC_DAYS = int(
    os.environ.get(
        "DEFAULT_METRIC_DAYS",
        "${metric_default_days}",
    )
)
MAX_METRIC_DAYS = int(
    os.environ.get(
        "MAX_METRIC_DAYS",
        "${metric_max_days}",
    )
)
MIN_METRIC_DAYS = int(
    os.environ.get(
        "MIN_METRIC_DAYS",
        "${metric_min_days}",
    )
)
DEFAULT_RETENTION_DAYS = int(
    os.environ.get(
        "DEFAULT_RETENTION_DAYS",
        "${retention_default_days}",
    )
)
MAX_RETENTION_DAYS = int(
    os.environ.get(
        "MAX_RETENTION_DAYS",
        "${retention_max_days}",
    )
)
MIN_RETENTION_DAYS = int(
    os.environ.get(
        "MIN_RETENTION_DAYS",
        "${retention_min_days}",
    )
)


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
    if log_group_name.startswith("/aws/"):
        new_retention = new_retention_for_log_group(
            default_retention=DEFAULT_METRIC_DAYS,
            max_retention=MAX_METRIC_DAYS,
            min_rentention=MIN_METRIC_DAYS,
            current_retention=current_retention,
        )
    else:
        new_retention = new_retention_for_log_group(
            default_retention=DEFAULT_RETENTION_DAYS,
            max_retention=MAX_RETENTION_DAYS,
            min_rentention=MIN_RETENTION_DAYS,
            current_retention=current_retention,
        )
    if new_retention is None:
        return
    logger.info(
        f"Updating retention for group {log_group_name}: {current_retention} -> {new_retention}"
    )
    log_client.put_retention_policy(
        logGroupName=log_group_name, retentionInDays=new_retention
    )


def ensure_log_group_retention_for_account():
    logger.info(f"Metric default is {DEFAULT_METRIC_DAYS}")
    logger.info(f"Metric max is {MAX_METRIC_DAYS}")
    logger.info(f"Metric min is {MIN_METRIC_DAYS}")
    logger.info(f"Retention default is {DEFAULT_RETENTION_DAYS}")
    logger.info(f"Retention max is {MAX_RETENTION_DAYS}")
    logger.info(f"Retention min is {MIN_RETENTION_DAYS}")
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
