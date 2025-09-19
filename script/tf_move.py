"""
This script provides an interactive shell that does the hard parts:
* Matching resource types in the plan file
* Copying long resource names
* Escaping quotes
"""

import itertools
import os
from typing import Optional, Tuple

import typer
from InquirerPy.inquirer import confirm, rawlist  # type: ignore

from .plan import get_plan_resources, resource_regex, run_command_as_process

resource_type_ignore_list = [
    "local_file",
]

resource_type_ignore_regex_map = {
    resource_type: resource_regex(resource_type)
    for resource_type in resource_type_ignore_list
}


def get_resource_types(change_to_resources: dict[str, list[str]]) -> list[str]:
    all_resources = list(
        itertools.chain.from_iterable(
            resource_list for resource_list in change_to_resources.values()
        )
    )
    resource_name_splits_raw = [
        resource_name.split(".") for resource_name in all_resources
    ]
    resource_name_splits_aws = [
        [
            split
            for split in splits
            if any(split.startswith(prefix) for prefix in ["github_", "aws_"])
            or any(
                split == resource
                for resource in [
                    "local_sensitive_file",
                    "random_password",
                    "tls_private_key",
                ]
            )
        ]
        for splits in resource_name_splits_raw
    ]
    if any(len(splits) != 1 for splits in resource_name_splits_aws):
        bad_splits = [
            resource_name_splits_raw[i_split]
            for i_split, splits in enumerate(resource_name_splits_aws)
            if len(splits) != 1
        ]
        raise ValueError(f"Resource names not understood: {bad_splits}")
    resource_types = set(splits[0] for splits in resource_name_splits_aws)
    return sorted(resource_types)


def map_resource_change_type(
    resource_type: str,
    change_type: str,
    resource_name: str,
    resources: dict[str, dict[str, list[str]]],
) -> None:
    if resource_type not in resources:
        resources[resource_type] = {}
    if change_type not in resources[resource_type]:
        resources[resource_type][change_type] = []
    resources[resource_type][change_type].append(resource_name)


def map_change_resource(
    change_type: str,
    resource_type_list: list[str],
    resource_name: str,
    resources: dict[str, dict[str, list[str]]],
) -> None:
    found = False
    for resource_type in resource_type_list:
        if f"{resource_type}." in resource_name:
            found = True
            map_resource_change_type(
                resource_type, change_type, resource_name, resources
            )
            break
    if not found:
        raise ValueError(f"Resource type not handled: {resource_name}")


def map_resources(
    rel_path: str,
    var_file: Optional[str],
    resource_ignore_list: list[str],
) -> Tuple[list[str], dict[str, dict[str, list[str]]], str]:
    change_to_resource_list, plan_out = get_plan_resources(
        rel_path, var_file, resource_type_ignore_regex_map, resource_ignore_list
    )
    resource_type_list = get_resource_types(change_to_resource_list)
    resources: dict[str, dict[str, list[str]]] = {}
    for change_type, resource_list in change_to_resource_list.items():
        for resource_name in resource_list:
            map_change_resource(
                change_type, resource_type_list, resource_name, resources
            )
    return resource_type_list, resources, plan_out


def prompt_user(
    resource_to_destroy: str,
    create_options: list[str],
    choice_for_ignore: int,
) -> int:
    create_options = create_options[:7]  # Max length of rawlist is 9
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
    if i_choice < choice_for_ignore:
        proceed = confirm(
            message=f"Move {resource_to_destroy}\n  ->   {create_options[i_choice]}?",
            default=True,
        ).execute()
        if not proceed:
            return len(create_options) + 1
    return i_choice


def move_resource(
    rel_path: str, resource_to_destroy: str, resource_to_create: str
) -> None:
    run_command_as_process(
        ["terraform", "state", "mv", resource_to_destroy, resource_to_create],
        cwd=rel_path,
    )


def change_one_resource_type(
    rel_path: str,
    resource_type: str,
    change_to_resources: dict[str, dict[str, list[str]]],
    resource_ignore_list: list[str],
) -> Optional[bool]:
    """Returns True if one resource was modified, or None to quit"""
    change_to_resource_list = change_to_resources[resource_type]
    moved_one = False
    while (
        len(change_to_resource_list) > 1
        and change_to_resource_list["destroyed"]
        and change_to_resource_list["created"]
    ):
        resource_to_destroy = change_to_resource_list["destroyed"].pop(0)
        create_options = change_to_resource_list["created"]
        choice_for_ignore = min(7, len(create_options))
        choice = prompt_user(resource_to_destroy, create_options, choice_for_ignore)
        if choice > choice_for_ignore:
            print("Quitting")
            return None
        elif choice == choice_for_ignore:
            print(f"Ignoring {resource_to_destroy}")
            resource_ignore_list.append(resource_to_destroy)
            moved_one = True
        else:
            print(f"Moving {resource_to_destroy} -> {create_options[choice]}")
            move_resource(rel_path, resource_to_destroy, create_options[choice])
            create_options.pop(choice)
            moved_one = True
    return moved_one


def change_all_resource_types(
    rel_path: str,
    resource_type_list: list[str],
    change_to_resources: dict[str, dict[str, list[str]]],
    resource_ignore_list: list[str],
) -> Optional[bool]:
    for resource_type in resource_type_list:
        if resource_type not in change_to_resources:
            continue
        moved_one = change_one_resource_type(
            rel_path, resource_type, change_to_resources, resource_ignore_list
        )
        if moved_one is not False:
            return moved_one
    return False


def print_final_plan(plan_out: str) -> None:
    print("No resources to change, exiting")
    print(plan_out)


def change_one_resource(
    rel_path: str, var_file: Optional[str], resource_ignore_list: list[str]
) -> bool:
    resource_type_list, change_to_resources, plan_out = map_resources(
        rel_path, var_file, resource_ignore_list
    )
    moved_one = change_all_resource_types(
        rel_path, resource_type_list, change_to_resources, resource_ignore_list
    )
    if moved_one is False:
        print_final_plan(plan_out)
    return moved_one or False


def move_resources(
    rel_path: str,
    profile: str,
    var_file: Optional[str] = None,
) -> None:
    os.environ["AWS_PROFILE"] = profile
    module_name = rel_path.split("/")[-1]
    print(f"Moving state for path {rel_path}, module {module_name}")
    resource_ignore_list: list[str] = []
    while change_one_resource(rel_path, var_file, resource_ignore_list):
        pass


def main(
    rel_path: str = typer.Argument(
        help="Relative path to application directory",
    ),
    profile: str = typer.Option(
        os.environ.get("AWS_PROFILE"),
        help="AWS profile to use",
    ),
    var_file: str | None = typer.Option(
        None,
        help="Relative path to variables file",
    ),
) -> None:
    move_resources(**locals())


if __name__ == "__main__":
    typer.run(main)
