"""
This script syncs CI dependencies to CDN because rate limits cause issues.
Example
python -m development.script.download_ci_dependencies
"""

import argparse
import json
import os
import shutil
from typing import Dict, List, Optional, Tuple

import hcl2
import s3path

from script.plan import run_command_as_process  # type:ignore

BUCKET = "cdn-bucket.calsev.com"


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
    args.add_argument(
        "--system",
        type=str,
        default="linux",
        help="The name of the AWS profile to use",
    )
    args.add_argument(
        "--arch",
        type=str,
        default="amd64",
        choices=["amd64", "arm64"],
        help="The name of the AWS profile to use",
    )
    parsed_args = args.parse_args(args_in)
    return parsed_args


def get_bin_versions() -> Tuple[str, str]:
    with open("development/ver_tf") as f:
        tf_ver = f.read()
    with open("development/ver_tflint") as f:
        tflint_ver = f.read()
    return tf_ver, tflint_ver


def get_linters(system: str, arch: str) -> Dict:
    with open("development/.tflint.hcl") as f:
        linter_data = hcl2.load(f)  # type: ignore
    linter_list = linter_data["plugin"]
    linter_map = {}
    for linter in linter_list:
        linter_map.update(**linter)
    for linter_name, linter_data in linter_map.items():
        linter_data["archive_name"] = (
            f"tflint_ruleset_{linter_name}_{system}_{arch}_{linter_data['version']}.zip"
        )
        linter_data["bin_name"] = f"tflint-ruleset-{linter_name}"
        linter_data["download_url"] = (
            "{}/tflint-ruleset-{}/releases/download/v{}/tflint-ruleset-{}_{}_{}.zip".format(
                "https://github.com/terraform-linters",
                linter_name,
                linter_data["version"],
                linter_name,
                system,
                arch,
            )
        )
    return linter_map


def get_release_info_for_repo(repo: str) -> Dict:
    """This can be used to get release info, including browser_download_url"""
    api_ver = "-H 'X-GitHub-Api-Version: 2022-11-28'"
    accept = "-H 'Accept: application/vnd.github+json'"
    command = f"gh api {accept} {api_ver} /repos/{repo}/releases/latest"
    result = run_command_as_process(command)
    text = result.stdout
    release_data = json.loads(text)
    return release_data


def download_asset_by_url(url: str, out_file: str) -> None:
    command = f"wget {url} -O {out_file}"
    run_command_as_process(command, expect_empty_stderr=False)


def asset_exists(out_file: str) -> bool:
    return s3path.S3Path(f"/{BUCKET}/installer/{out_file}").is_file()


def move_asset(out_file: str) -> None:
    command = f"aws s3 cp {out_file} s3://{BUCKET}/installer/{out_file}"
    run_command_as_process(command)
    os.remove(out_file)


def unzip_remove_and_upload_content(
    versioned_archive: str, versioned_file: str, bin_file: str
) -> None:
    run_command_as_process(f"unzip -o {versioned_archive}")
    os.remove(versioned_archive)
    os.chmod(bin_file, 0o755)
    print(f"Moving {bin_file} to {versioned_file}")
    shutil.move(bin_file, versioned_file)
    move_asset(versioned_file)


def transfer_binary_archive(
    bin_name: str, system: str, arch: str, version: str, url: str
) -> None:
    versioned_file = f"{bin_name.replace('-', '_')}_{system}_{arch}_{version}"
    versioned_archive = f"{versioned_file}.zip"
    if asset_exists(versioned_file):
        print(f"{bin_name.capitalize()} {versioned_file} exists, skipping")
        return
    download_asset_by_url(
        url,
        versioned_archive,
    )
    unzip_remove_and_upload_content(versioned_archive, versioned_file, bin_name)


def download_linters(arch: str, system: str) -> None:
    for repo_data in get_linters(system, arch).values():
        transfer_binary_archive(
            repo_data["bin_name"],
            system,
            arch,
            repo_data["version"],
            repo_data["download_url"],
        )


def download_ci_dependencies(
    profile: str,
    arch: str,
    system: str,
) -> None:
    os.environ["AWS_PROFILE"] = profile
    tf_ver, tflint_ver = get_bin_versions()
    download_linters(arch, system)
    transfer_binary_archive(
        "terraform",
        system,
        arch,
        tf_ver,
        f"https://releases.hashicorp.com/terraform/{tf_ver}/terraform_{tf_ver}_{system}_{arch}.zip",
    )
    transfer_binary_archive(
        "tflint",
        system,
        arch,
        tflint_ver,
        f"https://github.com/terraform-linters/tflint/releases/download/v{tflint_ver}/tflint_{system}_{arch}.zip",
    )


def main(
    args_in: Optional[List[str]] = None,
) -> None:
    args = parse_args(args_in)
    download_ci_dependencies(**vars(args))


if __name__ == "__main__":
    main()
