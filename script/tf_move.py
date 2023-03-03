"""
This script provides an interactive shell that does the hard parts:
* Matching resource types in the plan file
* Copying long resource names
* Escaping quotes
"""
import argparse
import os
from typing import Dict, List, Optional, Tuple

from InquirerPy.inquirer import confirm, rawlist  # type: ignore
from typeguard import typechecked

from .plan import get_plan_resources, resource_regex, run_command_as_process

# Lazy-building this list, so add as errors occur
resource_type_priority_list = [
    "aws_apigatewayv2_integration",
    "aws_autoscaling_group",
    "aws_batch_compute_environment",
    "aws_batch_job_definition",
    "aws_batch_job_queue",
    "aws_cloudfront_distribution",
    "aws_cloudfront_origin_access_control",
    "aws_cloudwatch_dashboard",
    "aws_cloudwatch_event_archive",
    "aws_cloudwatch_event_bus",
    "aws_cloudwatch_event_rule",
    "aws_cloudwatch_event_target",
    "aws_cloudwatch_log_group",
    "aws_cloudwatch_log_resource_policy",
    "aws_codebuild_project",
    "aws_codebuild_webhook",
    "aws_codepipeline",
    "aws_codestarconnections_connection",
    "aws_codestarconnections_host",
    "aws_db_instance",
    "aws_db_subnet_group",
    "aws_dynamodb_table",
    "aws_ecr_lifecycle_policy",
    "aws_ecr_repository",
    "aws_ecr_repository_policy",
    "aws_ecs_capacity_provider",
    "aws_ecs_cluster",
    "aws_ecs_cluster_capacity_providers",
    "aws_kms_key",
    "aws_launch_template",
    "aws_placement_group",
    "aws_route53_record",
    "aws_route_table_association",
    "aws_s3_bucket",
    "aws_s3_bucket_accelerate_configuration",
    "aws_s3_bucket_acl",
    "aws_s3_bucket_analytics_configuration",
    "aws_s3_bucket_cors_configuration",
    "aws_s3_bucket_intelligent_tiering_configuration",
    "aws_s3_bucket_inventory",
    "aws_s3_bucket_lifecycle_configuration",
    "aws_s3_bucket_logging",
    "aws_s3_bucket_metric",
    "aws_s3_bucket_notification",
    "aws_s3_bucket_object_lock_configuration",
    "aws_s3_bucket_ownership_controls",
    "aws_s3_bucket_policy",
    "aws_s3_bucket_public_access_block",
    "aws_s3_bucket_request_payment_configuration",
    "aws_s3_bucket_server_side_encryption_configuration",
    "aws_s3_bucket_versioning",
    "aws_s3_bucket_website_configuration",
    "aws_s3_bucket_accelerate_configuration",
    "aws_schemas_discoverer",
    "aws_security_group",
    "aws_security_group_rule",
    "aws_sfn_state_machine",
    "aws_sqs_queue",
    "aws_ssm_parameter",
    "aws_subnet",
    "aws_vpc",
    "aws_iam_instance_profile",
    "aws_iam_policy",
    "aws_iam_role",
    "aws_iam_role_policy",
    "aws_iam_role_policy_attachment",
    # "module",
]

resource_type_priority_regex_map = {
    resource_type: resource_regex(resource_type)
    for resource_type in resource_type_priority_list
}

resource_type_ignore_list = [
    "local_file",
]

resource_type_ignore_regex_map = {
    resource_type: resource_regex(resource_type)
    for resource_type in resource_type_ignore_list
}


@typechecked
def parse_args(args_in: Optional[List[str]] = None) -> argparse.Namespace:
    args = argparse.ArgumentParser()
    args.add_argument("path", type=str)
    args.add_argument("profile", type=str)
    args.add_argument("--var-file", type=str)
    parsed_args = args.parse_args(args_in)
    return parsed_args


@typechecked
def map_resource_change_type(
    resource_type: str, change_type: str, resource_name: str, resources: Dict
) -> None:
    if resource_type not in resources:
        resources[resource_type] = {}
    if change_type not in resources[resource_type]:
        resources[resource_type][change_type] = []
    resources[resource_type][change_type].append(resource_name)


@typechecked
def map_change_resource(change_type: str, resource_name: str, resources: Dict) -> None:
    found = False
    for resource_type in resource_type_priority_regex_map:
        if resource_type_priority_regex_map[resource_type].search(resource_name):
            found = True
            map_resource_change_type(
                resource_type, change_type, resource_name, resources
            )
            break
    if not found:
        raise ValueError(f"Resource type not handled: {resource_name}")


@typechecked
def map_resources(
    rel_path: str,
    var_file: Optional[str],
    resource_ignore_list: List,
) -> Tuple[Dict[str, Dict[str, List[str]]], str]:
    change_map, plan_out = get_plan_resources(
        rel_path, var_file, resource_type_ignore_regex_map, resource_ignore_list
    )
    resources = {}
    for change_type, resource_list in change_map.items():
        for resource_name in resource_list:
            map_change_resource(change_type, resource_name, resources)
    print(resources)
    return resources, plan_out


@typechecked
def prompt_user(resource_to_destroy: str, create_options: List[str]) -> int:
    choices = [
        *[f"Alias - {create_option}" for create_option in create_options],
        f"Ignore {resource_to_destroy}",
        "Quit",
    ]
    print("\n")
    choice = rawlist(
        message=f"Destroying {resource_to_destroy}:",
        choices=choices,
        validate=lambda result: len(result) > 1,
    ).execute()
    i_choice = choices.index(choice)
    if i_choice < len(create_options):
        proceed = confirm(
            message=f"Move {resource_to_destroy} -> {create_options[i_choice]}?",
            default=True,
        ).execute()
        if not proceed:
            return len(create_options) + 1
    return i_choice


@typechecked
def move_resource(
    rel_path: str, resource_to_destroy: str, resource_to_create: str
) -> None:
    cmd = f"terraform state mv {resource_to_destroy} {resource_to_create}"
    run_command_as_process(cmd, cwd=rel_path)


@typechecked
def change_one_resource_type(
    rel_path: str,
    resource_type: str,
    change_to_resources: Dict,
    resource_ignore_list: List,
) -> Optional[bool]:
    """Returns True if one resource was modified, or None to quit"""
    change_map = change_to_resources[resource_type]
    moved_one = False
    while len(change_map) > 1 and change_map["destroyed"] and change_map["created"]:
        resource_to_destroy = change_map["destroyed"].pop(0)
        create_options = change_map["created"]
        choice = prompt_user(resource_to_destroy, create_options)
        if choice > len(create_options):
            print("Quitting")
            return None
        elif choice == len(create_options):
            print(f"Ignoring {resource_to_destroy}")
            resource_ignore_list.append(resource_to_destroy)
            moved_one = True
        else:
            print(f"Moving {resource_to_destroy} -> {create_options[choice]}")
            move_resource(rel_path, resource_to_destroy, create_options[choice])
            create_options.pop(choice)
            moved_one = True
    return moved_one


@typechecked
def change_all_resource_types(
    rel_path: str,
    change_to_resources: Dict,
    resource_ignore_list: List[str],
) -> Optional[bool]:
    for resource_type in resource_type_priority_list:
        if resource_type not in change_to_resources:
            continue
        moved_one = change_one_resource_type(
            rel_path, resource_type, change_to_resources, resource_ignore_list
        )
        if moved_one is not False:
            return moved_one
    return False


@typechecked
def print_final_plan(plan_out: str) -> None:
    print("No resources to change, exiting")
    print(plan_out)


@typechecked
def change_one_resource(
    rel_path: str, var_file: Optional[str], resource_ignore_list: List[str]
) -> bool:
    change_to_resources, plan_out = map_resources(
        rel_path, var_file, resource_ignore_list
    )
    moved_one = change_all_resource_types(
        rel_path, change_to_resources, resource_ignore_list
    )
    if moved_one is False:
        print_final_plan(plan_out)
    return moved_one or False


@typechecked
def move_resources(
    rel_path: str, aws_profile: str, var_file: Optional[str] = None
) -> None:
    os.environ["AWS_PROFILE"] = aws_profile
    module_name = rel_path.split("/")[-1]
    print(f"Moving state for path {rel_path}, module {module_name}")
    resource_ignore_list = []
    while change_one_resource(rel_path, var_file, resource_ignore_list):
        pass


@typechecked
def main(args_in: Optional[List[str]] = None) -> None:
    args = parse_args(args_in)
    move_resources(args.path, args.profile, args.var_file)


if __name__ == "__main__":
    main()
