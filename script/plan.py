import json
import os
import re
import shlex
import subprocess
import typing


def resource_regex(resource_type: str) -> re.Pattern[typing.Any]:
    return re.compile(rf"(?:^|[\s\.]){resource_type}[\.\[]")


def run_command_as_process(
    command: typing.Union[str, list[str]],
    cwd: typing.Optional[str] = None,
    expected_return_code: typing.Optional[int] = 0,
    expected_stdout: typing.Union[
        str,
        re.Pattern[typing.Any],
        list[typing.Union[str, re.Pattern[typing.Any]]],
        None,
    ] = None,
    expect_empty_stderr: bool = True,
    env: typing.Optional[dict[str, str]] = None,
) -> subprocess.CompletedProcess[typing.Any]:
    """
    @param command: The command string to execute
    @param cwd: The working directory, if not the current directory
    @param expected_return_code: If not None, the return code will be checked against this
    @param expected_stdout: If not None, the output of the command will be matched to this
    @param expect_empty_stderr: If True, the error output will be checked to make sure it is empty
    @param env: A dictionary of environment variables to add to the inherited environment
    @return: The process object
    """
    # So we do not have to use shell form
    if isinstance(command, str):
        command = json.dumps(command)[1:-1]  # Escape characters
        arg_list = shlex.split(command)
    else:
        arg_list = command
    print(f"Running {json.dumps(arg_list, indent='  ')}")
    if env:
        env = {**os.environ, **env}
    result = subprocess.run(
        arg_list,
        cwd=cwd,
        capture_output=True,
        text=True,
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


def process_change_type(
    line: str,
    change_type: str,
    resources: dict[str, list[str]],
    resource_type_ignore_regex_map: dict[str, re.Pattern[typing.Any]],
    resource_ignore_list: list[str],
) -> None:
    splits = [p for p in re.split(r"([^\s\"]+(?:\".+?\"\S+)*|\s+)", line) if p.strip()]
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


def process_plan_line(
    line: str,
    resources: dict[str, list[str]],
    resource_type_ignore_regex_map: dict[str, re.Pattern[typing.Any]],
    resource_ignore_list: list[str],
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


def get_plan_resources(
    rel_path: str,
    var_file: str | None,
    resource_type_ignore_regex_map: dict[str, re.Pattern[typing.Any]],
    resource_ignore_list: list[str],
) -> tuple[dict[str, list[str]], str]:
    print("Fetching current plan ...")
    var_file = f"--var-file {var_file}.tfvars" if var_file else ""
    result = run_command_as_process(
        f"terraform plan{var_file} -out plan.tfplan -no-color", cwd=rel_path
    )
    change_to_resource_list: dict[str, list[str]] = {
        "created": [],
        "destroyed": [],
    }
    lines = result.stdout.split("\n")
    print(f"Read {len(lines)} lines")
    for line in lines:
        process_plan_line(
            line,
            change_to_resource_list,
            resource_type_ignore_regex_map,
            resource_ignore_list,
        )
    return change_to_resource_list, result.stdout
