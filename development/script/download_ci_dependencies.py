"""
This script syncs CI dependencies to CDN because rate limits cause issues.
Example
python -m development.script.download_ci_dependencies
"""
import argparse
import json
import os
import platform
from typing import Dict, List, Optional

from typeguard import typechecked

from script.plan import run_command_as_process  # type:ignore


@typechecked
def parse_args(
    args_in: Optional[List[str]] = None,
) -> argparse.Namespace:
    args = argparse.ArgumentParser()
    args.add_argument(
        "--profile",
        type=str,
        default="default",
        help="The name of the AWS profile to use",
    )
    parsed_args = args.parse_args(args_in)
    return parsed_args


@typechecked
def get_deps() -> Dict:
    system = platform.system().lower()
    arch = "amd64"
    return {
        "terraform-linters/tflint": {
            "name": f"tflint_{system}_{arch}.zip",
        },
        "terraform-linters/tflint-ruleset-aws": {
            "name": f"tflint-ruleset-aws_{system}_{arch}.zip",
        },
        "terraform-linters/tflint-ruleset-terraform": {
            "name": f"tflint-ruleset-terraform_{system}_{arch}.zip",
        },
    }


@typechecked
def download_latest_version(repo: str) -> Dict:
    api_ver = "-H 'X-GitHub-Api-Version: 2022-11-28'"
    accept = "-H 'Accept: application/vnd.github+json'"
    command = f"gh api {accept} {api_ver} /repos/{repo}/releases/latest"
    result = run_command_as_process(command)
    text = result.stdout
    data = json.loads(text)
    return data


@typechecked
def get_version_url(repo_data: Dict, data: Dict) -> str:
    url = None
    for asset in data["assets"]:
        if asset["name"] == repo_data["name"]:
            url = asset["url"]
    if not url:
        raise ValueError(
            f"URL not found for {repo_data['name']}: {json.dumps(data, indent='  ')}"
        )
    return url


@typechecked
def get_browser_url(repo_data: Dict, data: Dict) -> str:
    url = None
    for asset in data["assets"]:
        if asset["name"] == repo_data["name"]:
            url = asset["browser_download_url"]
    if not url:
        raise ValueError(
            f"URL not found for {repo_data['name']}: {json.dumps(data, indent='  ')}"
        )
    return url


@typechecked
def get_asset_id(repo_data: Dict, data: Dict) -> str:
    asset_id = None
    for asset in data["assets"]:
        if asset["name"] == repo_data["name"]:
            asset_id = asset["id"]
    if not asset_id:
        raise ValueError(
            f"URL not found for {repo_data['name']}: {json.dumps(data, indent='  ')}"
        )
    return str(asset_id)


@typechecked
def get_outfile(repo_data: Dict, data: Dict) -> str:
    base_name = repo_data["name"].split(".")[0]
    ext = ".".join(repo_data["name"].split(".")[1:])
    out_file = f"{base_name}-{data['tag_name']}.{ext}"
    return out_file


@typechecked
def download_asset_by_url(url: str, out_file: str) -> None:
    command = f"wget {url} -O {out_file}"
    run_command_as_process(command, expect_empty_stderr=False)


@typechecked
def download_asset_by_id(repo: str, asset_id: str, out_file: str) -> None:
    api_ver = "-H 'X-GitHub-Api-Version: 2022-11-28'"
    accept = "-H 'Accept: application/octet-stream'"

    command = f"gh api {accept} {api_ver} /repos/{repo}/releases/assets/{asset_id}"
    run_command_as_process(command, expect_empty_stderr=False)


@typechecked
def move_asset(out_file: str) -> None:
    command = f"aws s3 cp {out_file} s3://cdn-bucket.calsev.com/installer/{out_file}"
    run_command_as_process(command)
    os.remove(out_file)


@typechecked
def download_ci_dependencies(
    profile: str,
) -> None:
    os.environ["AWS_PROFILE"] = profile
    for repo, repo_data in get_deps().items():
        data = download_latest_version(repo)
        browser_url = get_browser_url(repo_data, data)

        out_file = get_outfile(repo_data, data)
        download_asset_by_url(browser_url, out_file)

        move_asset(out_file)


@typechecked
def main(
    args_in: Optional[List[str]] = None,
) -> None:
    args = parse_args(args_in)
    download_ci_dependencies(**vars(args))


if __name__ == "__main__":
    main()
