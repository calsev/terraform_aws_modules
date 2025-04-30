"""
This script imports the several resources that comprise an S3 bucket.
Example
python script/s3_import.py stack/inf/s3 aws-profile-name
"""

import os
import shlex
import typing

import typer

from .plan import get_plan_resources, resource_regex, run_command_as_process

resource_type_priority_list = [
    "aws_s3_bucket",
    "aws_s3_bucket_accelerate_configuration",
    "aws_s3_bucket_acl",
    "aws_s3_bucket_cors_configuration",
    "aws_s3_bucket_lifecycle_configuration",
    "aws_s3_bucket_ownership_controls",
    "aws_s3_bucket_policy",
    "aws_s3_bucket_public_access_block",
    "aws_s3_bucket_server_side_encryption_configuration",
    "aws_s3_bucket_versioning",
    "aws_s3_bucket_website_configuration",
    # TODO: aws_s3_bucket_analytics_configuration,
    # TODO: aws_s3_bucket_intelligent_tiering_configuration,
    # TODO: aws_s3_bucket_inventory,
    "aws_s3_bucket_logging",
    # TODO: aws_s3_bucket_metric,
    "aws_s3_bucket_notification",
    # TODO: aws_s3_bucket_object_lock_configuration,
    "aws_s3_bucket_request_payment_configuration",
]

resource_type_priority_regex_map = {
    resource_type: resource_regex(resource_type)
    for resource_type in resource_type_priority_list
}


def get_bucket_key(
    resource_name: str,
) -> str:
    parser = shlex.shlex(resource_name)
    parser.whitespace = "."
    bucket_segments = list(parser)
    print(bucket_segments)
    bucket_index = bucket_segments.index("this_bucket")
    bucket_key = bucket_segments[bucket_index + 2]  # [ then key
    if bucket_key[0] != '"' or bucket_key[-1] != '"':
        raise ValueError(
            f"Could not understand bucket key '{resource_name}', {bucket_segments}, {bucket_key}"
        )
    bucket_key = bucket_key[1:-1]
    print(f"Found bucket {bucket_key}")
    return bucket_key


def build_bucket_map(
    bucket_name: str | None,
    resource_list: list[str],
) -> dict[str, dict[str, typing.Any]]:
    bucket_map: dict[str, dict[str, typing.Any]] = {}
    for resource_name in resource_list:
        if "aws_s3_bucket.this_bucket" in resource_name:
            bucket_key = get_bucket_key(resource_name=resource_name)
            bucket_map[bucket_key] = {
                "bucket_name": bucket_name or bucket_key,
                "resource_list": [],
            }
    return bucket_map


def map_resources(
    rel_path: str,
    var_file: str | None,
    bucket_name: str | None,
) -> dict[str, dict[str, typing.Any]]:
    change_to_resource_list, _ = get_plan_resources(rel_path, var_file, {}, [])
    resource_list = change_to_resource_list["created"]
    bucket_map = build_bucket_map(bucket_name, resource_list)
    for resource_name in resource_list:
        for bucket_key, bucket_data in bucket_map.items():
            if bucket_key in resource_name:
                bucket_data["resource_list"].append(resource_name)
                break
    print(f"Bucket map:\n{bucket_map}")
    return bucket_map


def import_one_resource(
    rel_path: str,
    var_file: str | None,
    bucket_name: str,
    resource_name: str,
) -> None:
    if "aws_s3_bucket_acl" in resource_name:
        bucket_name = f"{bucket_name},private"
    cmd = f"terraform import{var_file} {resource_name} {bucket_name}"
    try:
        run_command_as_process(cmd, cwd=rel_path)
    except RuntimeError as e:
        print(f"Could not import {resource_name}:\n{e}")


def import_all_resources(
    rel_path: str,
    var_file: str | None,
    bucket_map: dict[str, dict[str, typing.Any]],
) -> None:
    var_file = f"--var-file {var_file}.tfvars" if var_file else ""
    for bucket_data in bucket_map.values():
        for resource_name in bucket_data["resource_list"]:
            import_one_resource(
                rel_path, var_file, bucket_data["bucket_name"], resource_name
            )


def import_buckets(
    rel_path: str,
    aws_profile: str,
    var_file: str | None = None,
    bucket_name: str | None = None,
) -> None:
    os.environ["AWS_PROFILE"] = aws_profile
    module_name = rel_path.split("/")[-1]
    print(f"Importing buckets for path {rel_path}, module {module_name}")
    bucket_map = map_resources(rel_path, var_file, bucket_name)
    import_all_resources(rel_path, var_file, bucket_map)


def main(
    rel_path: str = typer.Argument(),
    aws_profile: str = typer.Argument(),
    var_file: str | None = typer.Option(
        None,
    ),
    bucket_name: str | None = typer.Option(
        None,
    ),
) -> None:
    import_buckets(**locals())


if __name__ == "__main__":
    typer.run(main)
