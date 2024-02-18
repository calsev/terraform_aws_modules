"""
This script imports the several resources that comprise an S3 bucket.
Example
python script/s3_import.py stack/inf/s3 gobble
"""

import argparse
import os
import shlex
from typing import Dict, List, Optional

from typeguard import typechecked

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
    # TODO: aws_s3_bucket_analytics_configuration
    # TODO: aws_s3_bucket_intelligent_tiering_configuration
    # TODO: aws_s3_bucket_inventory
    # TODO: aws_s3_bucket_logging
    # TODO: aws_s3_bucket_metric
    "aws_s3_bucket_notification",
    # TODO: aws_s3_bucket_object_lock_configuration
    "aws_s3_bucket_request_payment_configuration",
]

resource_type_priority_regex_map = {
    resource_type: resource_regex(resource_type)
    for resource_type in resource_type_priority_list
}


@typechecked
def parse_args(args_in: Optional[List[str]] = None) -> argparse.Namespace:
    args = argparse.ArgumentParser()
    args.add_argument(
        "path", type=str, help="The relative path to the app, e.g. stack/inf/s3"
    )
    args.add_argument("profile", type=str, help="The name of the AWS profile to use")
    args.add_argument("--var-file", type=str)
    parsed_args = args.parse_args(args_in)
    return parsed_args


@typechecked
def build_bucket_map(
    resource_list: List[str],
) -> Dict[str, List]:
    bucket_map = {}
    for resource_name in resource_list:
        if "aws_s3_bucket.this_bucket" in resource_name:
            parser = shlex.shlex(resource_name)
            parser.whitespace = "."
            bucket_segments = list(parser)
            print(bucket_segments)
            bucket_index = bucket_segments.index("this_bucket")
            bucket_name = bucket_segments[bucket_index + 2]  # [ then name
            if bucket_name[0] != '"' or bucket_name[-1] != '"':
                raise ValueError(
                    f"Could not understand bucket name '{resource_name}', {bucket_segments}, {bucket_name}"
                )
            bucket_name = bucket_name[1:-1]
            print(f"Found bucket {bucket_name}")
            bucket_map[bucket_name] = []  # TODO: This handles only one name
    return bucket_map


@typechecked
def map_resources(
    rel_path: str,
    var_file: Optional[str],
) -> Dict[str, List[str]]:
    change_to_resource_list, _ = get_plan_resources(rel_path, var_file, {}, [])
    resource_list = change_to_resource_list["created"]
    bucket_map = build_bucket_map(resource_list)
    for resource_name in resource_list:
        for bucket_name, name_map in bucket_map.items():
            if bucket_name in resource_name:
                name_map.append(resource_name)
                break
    print(f"Bucket map:\n{bucket_map}")
    return bucket_map


@typechecked
def import_one_resource(
    rel_path: str, var_file: Optional[str], bucket_name: str, resource_name: str
) -> None:
    if "aws_s3_bucket_acl" in resource_name:
        bucket_name = f"{bucket_name},private"
    cmd = f"terraform import{var_file} {resource_name} {bucket_name}"
    try:
        run_command_as_process(cmd, cwd=rel_path)
    except RuntimeError as e:
        print(f"Could not import {resource_name}:\n{e}")


@typechecked
def import_all_resources(
    rel_path: str, var_file: Optional[str], bucket_map: Dict[str, List[str]]
) -> None:
    var_file = f"--var-file {var_file}.tfvars" if var_file else ""
    for bucket_name, resource_list in bucket_map.items():
        for resource_name in resource_list:
            import_one_resource(rel_path, var_file, bucket_name, resource_name)


@typechecked
def import_buckets(
    rel_path: str, aws_profile: str, var_file: Optional[str] = None
) -> None:
    os.environ["AWS_PROFILE"] = aws_profile
    module_name = rel_path.split("/")[-1]
    print(f"Importing buckets for path {rel_path}, module {module_name}")
    bucket_map = map_resources(rel_path, var_file)
    import_all_resources(rel_path, var_file, bucket_map)


@typechecked
def main(args_in: Optional[List[str]] = None) -> None:
    args = parse_args(args_in)
    import_buckets(args.path, args.profile, args.var_file)


if __name__ == "__main__":
    main()
