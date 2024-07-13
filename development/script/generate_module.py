"""
Generate a resource map and locals for a resource.

* Copy module_template to the desired location.
* Populate the resource in main.tf with each.value.attribute values
* Run this script on the module

Example

  python -m development.script.generate_module elb/load_balancer resource.aws_lb.this_lb elb
"""

import argparse
import os
import re
import textwrap
import typing

import hcl2

NAME_PREFIXES = ["name_", "tags"]
NAME_VARIABLES = {
    "name_append": "bool",
    "name_include_app_fields": "bool",
    "name_infix": "bool",
    "name_prefix": "string",
    "name_prepend": "bool",
    "name_suffix": "string",
}
VPC_PREFIXES = ["security_group_", "subnet_", "vpc_"]
VPC_VARIABLES = {
    "vpc_az_key_list": "list(string)",
    "vpc_key": "string",
    "vpc_security_group_key_list": "list(string)",
    "vpc_segment_key": "string",
}
ALL_PREFIXES = [*NAME_VARIABLES.values(), *VPC_PREFIXES]


def parse_args(
    args_in: typing.Optional[list[str]] = None,
) -> argparse.Namespace:
    args = argparse.ArgumentParser()
    args.add_argument(
        "module_path",
        type=str,
    )
    args.add_argument(
        "resource_path",
        type=str,
    )
    args.add_argument(
        "variable_prefix",
        type=str,
    )
    parsed_args = args.parse_args(args_in)
    return parsed_args


class ModuleData:
    def __init__(
        self,
        module_path: str,
        variable_data: dict[str, typing.Any],
        local_data: dict[str, typing.Any],
        main_data: dict[str, typing.Any],
    ) -> None:
        self.module_path = module_path
        self.variable_data = variable_data
        self.local_data = local_data
        self.main_data = main_data

        self.uses_vpc = False


def read_module(module_path: str) -> ModuleData:
    with open(os.path.join(module_path, "main.tf")) as f:
        main_data = typing.cast(
            dict[str, typing.Any],
            hcl2.load(f),  # type: ignore
        )
    return ModuleData(module_path, {}, {}, main_data)


def extract_resource_data(
    module_data: ModuleData,
    resource_path: str,
) -> dict[str, typing.Any]:
    resource_data: typing.Any = module_data.main_data
    key = ""
    segments_to_search = resource_path.split(".")
    segments_searched: list[str] = []
    while segments_to_search:
        key = key if key else segments_to_search.pop(0)
        if isinstance(resource_data, dict):
            resource_data = resource_data[key]
            segments_searched.append(key)
            key = ""
        elif isinstance(resource_data, list):
            resource_data = [
                data
                for data in typing.cast(list[dict[str, typing.Any]], resource_data)
                if key in data
            ]
            if len(resource_data) < 1:
                raise ValueError(
                    f"Key {key} not found in {'.'.join(segments_searched)}"
                )
            elif len(resource_data) > 1:
                index = int(segments_to_search.pop(0))
                resource_data = resource_data[index]
            else:
                resource_data = resource_data[0]
        else:
            raise ValueError(f"Unknown resource type {type(resource_data)}")
    return resource_data


variable_regex = re.compile(r"each\.value\.(\w+)")


def extract_variable_set(resource_data: typing.Any, variable_set: set[str]) -> None:
    item: typing.Any
    if isinstance(resource_data, str):
        variables = variable_regex.findall(resource_data)
        variable_set.update(variables)
    elif isinstance(resource_data, dict):
        for item in resource_data.values():
            extract_variable_set(item, variable_set)
    elif isinstance(resource_data, list):
        for item in resource_data:
            extract_variable_set(
                item,
                variable_set,
            )
    elif isinstance(resource_data, (int, float, type(None))):
        pass
    else:
        raise ValueError(f"Unrecognized type {type(resource_data)}")


def standardize_variables(module_data: ModuleData, variable_set: set[str]) -> list[str]:
    vpc_var_list = [
        variable
        for variable in variable_set
        if any(variable.startswith(pre) for pre in VPC_PREFIXES)
    ]
    module_data.uses_vpc = len(vpc_var_list) != 0
    variable_set.difference_update(vpc_var_list)
    variable_list = sorted(
        variable
        for variable in variable_set
        if not any(variable.startswith(pre) for pre in NAME_PREFIXES)
    )
    return variable_list


def get_or_create_resource_map(
    variable_prefix: str, variable_data: list[dict[str, typing.Any]]
) -> dict[str, typing.Any]:
    resource_map_name = f"{variable_prefix}_map"
    resource_map = None
    for variable in variable_data:
        if "resource_map" in variable:
            variable[resource_map_name] = variable.pop("resource_map")
            resource_map = variable
            break
        elif resource_map_name in variable:
            resource_map = variable
    if not resource_map:
        raise ValueError("Could not find resource map")
    return resource_map[resource_map_name]


def default_type_for_variable(variable: str) -> str:
    if any(
        variable.endswith(suffix)
        for suffix in [
            "allowed",
            "disabled",
            "enabled",
            "enforced",
            "excluded",
            "included",
            "only",
        ]
    ):
        return "bool"
    if any(
        variable.endswith(suffix) for suffix in ["days", "hours", "seconds", "value"]
    ):
        return "number"
    if variable.endswith("list"):
        return "list(string)"
    if variable.endswith("map"):
        return "map(object({}))"
    return "string"


def generate_variables(
    variable_prefix: str, module_data: ModuleData, variable_list: list[str]
) -> None:
    variable_map = {
        # **NAME_VARIABLES,
        **(VPC_VARIABLES if module_data.uses_vpc else {}),
        **{variable: default_type_for_variable(variable) for variable in variable_list},
    }
    variable_map = {k: variable_map[k] for k in sorted(variable_map.keys())}
    path = os.path.abspath(os.path.join("development", "module_gen", "variables.tf"))
    with open(path, "w") as f:
        f.write(
            textwrap.dedent(
                f"""
                variable "{variable_prefix}_map" {{
                  type = map(object({{
                """
            )
        )
        for k_var, t_var in variable_map.items():
            f.write(f"    {k_var} = optional({t_var})\n")
        f.write(
            textwrap.dedent(
                """
                  }))
                }
                """
            )
        )
        for k_var, t_var in variable_map.items():
            variable_name = (
                f"{k_var}_default"
                if (
                    any(k_var.startswith(prefix) for prefix in ALL_PREFIXES)
                    or k_var.startswith(variable_prefix)
                )
                else f"{variable_prefix}_{k_var}_default"
            )
            f.write(
                textwrap.dedent(
                    f"""
                    variable "{variable_name}" {{
                      type = {t_var}
                      default = null"""
                )
            )
            if t_var != "bool":
                f.write(
                    f"""
  validation {{
      condition     = contains([], var.{variable_prefix}_{k_var}_default)
      error_message = "Invalid {k_var.replace('_', ' ')}"
  }}"""
                )
            f.write("\n}\n")


def generate_locals(
    variable_prefix: str, module_data: ModuleData, variable_list: list[str]
) -> None:
    path = os.path.abspath(os.path.join("development", "module_gen", "locals.tf"))
    with open(path, "w") as f:
        for variable in variable_list:
            def_name = (
                variable
                if variable.startswith(variable_prefix)
                else f"{variable_prefix}_{variable}"
            )
            f.write(
                f"      {variable} = v.{variable} == null ? var.{def_name}_default : v.{variable}\n"
            )


def populate_module(
    module_data: ModuleData,
    resource_path: str,
    variable_prefix: str,
) -> None:
    resource_data = extract_resource_data(module_data, resource_path)
    variable_set: set[str] = set()
    extract_variable_set(resource_data, variable_set)
    variable_list = standardize_variables(module_data, variable_set)
    os.makedirs(os.path.join("development", "module_gen"), exist_ok=True)
    generate_variables(variable_prefix, module_data, variable_list)
    generate_locals(variable_prefix, module_data, variable_list)


def write_module(module_data: ModuleData) -> None:
    pass  # TODO: The parsed HCL for var types is just a big string


def generate_module(
    module_path: str,
    resource_path: str,
    variable_prefix: str,
) -> None:
    module_data = read_module(module_path)
    populate_module(module_data, resource_path, variable_prefix)
    write_module(module_data)


def main(
    args_in: typing.Optional[list[str]] = None,
) -> None:
    args = parse_args(args_in)
    generate_module(**vars(args))


if __name__ == "__main__":
    main()
