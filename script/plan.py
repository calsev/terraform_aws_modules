import json
import re
import shlex
import subprocess
from typing import Dict, List, Optional, Tuple

from typeguard import typechecked


@typechecked
def resource_regex(resource_type: str) -> re.Pattern:
    return re.compile(rf"(?:^|[\s\.]){resource_type}[\.\[]")


@typechecked
def run_command_as_process(
    command: str,
    cwd: Optional[str] = None,
    return_code: Optional[int] = 0,
    empty_err: bool = True,
) -> subprocess.CompletedProcess:
    print(f"Running '{command}'")
    command = json.dumps(command)[1:-1]
    arg_list = shlex.split(command)
    result = subprocess.run(
        arg_list,
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
    )
    if (
        return_code is not None
        and result.returncode != return_code
        or empty_err
        and result.stderr
    ):
        raise RuntimeError(
            f"Command {command} failed ({result.returncode}): {result.stderr}"
        )
    return result


@typechecked
def process_change_type(
    line: str,
    change_type: str,
    resources: Dict,
    resource_type_ignore_regex_map: Dict,
    resource_ignore_list: List,
) -> None:
    splits = line.split(" ")
    print(splits)
    resource_name = splits[1]
    if any(
        resource_type_ignore_regex_map[resource_type].search(resource_name)
        for resource_type in resource_type_ignore_regex_map
    ):
        print(f"Ignoring {resource_name}")
        return
    if resource_name not in resource_ignore_list:
        resources[change_type].append(resource_name)


@typechecked
def process_plan_line(
    line: str,
    resources: Dict,
    resource_type_ignore_regex_map: Dict,
    resource_ignore_list: List,
) -> None:
    line = line.strip()
    for change_type in resources:
        if line.endswith(change_type):
            process_change_type(
                line,
                change_type,
                resources,
                resource_type_ignore_regex_map,
                resource_ignore_list,
            )


@typechecked
def get_plan_resources(
    rel_path: str,
    var_file: Optional[str],
    resource_type_ignore_regex_map: Dict,
    resource_ignore_list: List[str],
) -> Tuple[Dict[str, List[str]], str]:
    print("Fetching current plan ...")
    var_file = f"--var-file {var_file}.tfvars" if var_file else ""
    result = run_command_as_process(
        f"terraform plan{var_file} -out plan.tfplan -no-color", cwd=rel_path
    )
    resources = {
        "created": [],
        "destroyed": [],
    }
    lines = result.stdout.split("\n")
    print(f"Read {len(lines)} lines")
    for line in lines:
        process_plan_line(
            line, resources, resource_type_ignore_regex_map, resource_ignore_list
        )
    print(resources)
    return resources, result.stdout
