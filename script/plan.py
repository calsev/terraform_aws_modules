import json
import os
import re
import shlex
import subprocess
from typing import Dict, List, Optional, Tuple, Union

from typeguard import typechecked


@typechecked
def resource_regex(resource_type: str) -> re.Pattern:
    return re.compile(rf"(?:^|[\s\.]){resource_type}[\.\[]")


@typechecked
def run_command_as_process(
    command: str,
    cwd: Optional[str] = None,
    expected_return_code: Optional[int] = 0,
    expected_stdout: Union[str, re.Pattern, List[Union[str, re.Pattern]], None] = None,
    expect_empty_stderr: bool = True,
    env: Optional[Dict[str, str]] = None,
) -> subprocess.CompletedProcess:
    """
    @param command: The command string to execute
    @param cwd: The working directory, if not the current directory
    @param expected_return_code: If not None, the return code will be checked against this
    @param expected_stdout: If not None, the output of the command will be matched to this
    @param expect_empty_stderr: If True, the error output will be checked to make sure it is empty
    @param env: A dictionary of environment variables to add to the inherited environment
    @return: The process object
    """
    print(f"Running '{command}'")
    command = json.dumps(command)[1:-1]  # Escape characters
    arg_list = shlex.split(command)  # So we do not have to use shell form
    if env:
        env = {**os.environ, **env}
    result = subprocess.run(
        arg_list,
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        env=env,
    )
    return_matches = (
        expected_return_code is None or result.returncode == expected_return_code
    )
    err_matches = not expect_empty_stderr or not result.stderr
    if not return_matches or not err_matches:
        raise RuntimeError(
            f"Command {command} failed ({result.returncode}):\n{result.stderr}"
        )
    if expected_stdout:
        expected_stdout = (
            expected_stdout if isinstance(expected_stdout, list) else [expected_stdout]
        )
        for match in expected_stdout:
            if (
                isinstance(match, str)
                and match not in result.stdout
                or isinstance(match, re.Pattern)
                and not re.search(match, result.stdout)
            ):
                raise RuntimeError(
                    f"Command {command} output does not match '{match}':\n{result.stdout}"
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
