"""Generate a Makefile with targets for each stack because they are very repetitive"""
import argparse
import json
import os
import shutil
from typing import Any, Dict, List, Optional

import jinja2
from typeguard import typechecked

jinja_loader = jinja2.FileSystemLoader(searchpath=".")
jinja_env = jinja2.Environment(loader=jinja_loader)


@typechecked
def parse_args(args_in: Optional[List[str]] = None) -> argparse.Namespace:
    args = argparse.ArgumentParser()
    args.add_argument(
        "--template",
        type=str,
        default="in.Makefile",
        help="Relative path to the Makefile template to render",
    )
    args.add_argument(
        "--makefile",
        type=str,
        default="Makefile",
        help="Relative path to the makefile",
    )
    args.add_argument(
        "--module-root",
        type=str,
        default="modules",
        help="Relative path to the module root",
    )
    args.add_argument(
        "--module-postfixes",
        type=str,
        nargs="+",
        default=["modules"],
        help="List of filters for Terraform module parent directories to lint",
    )
    args.add_argument(
        "--module-ignore-postfixes",
        type=str,
        nargs="+",
        default=[],
        help="List of filters for parent subdirectories directories to ignore",
    )
    args.add_argument(
        "--tf-root",
        type=str,
        default="stack",
        help="Relative path to the root of Terraform stacks",
    )
    args.add_argument(
        "--env-template",
        type=str,
        default="../env/template.env",
        help="Relative path to the template environment file",
    )
    args.add_argument(
        "--env-file",
        type=str,
        default="../env/.env",
        help="Relative path to the environment file. "
        "If it does not exist, the template will be copied to this location.",
    )
    args.add_argument(
        "provisioning_directories",
        type=str,
        help="""
        A JSON object containing provisioning directories. For example:
        {
          "stack1": {
            "app": {
              "my_app": {
                "var_file": "prod.tfvars"
              }
            },
            "aws_profile": "MY_PROFILE",
            "skip_plan": [
              "obsolete_app"
            ]
          },
          "stack2": {}
        }
        AWs profiles are common to the repo and mapped in an env file, e.g.
        AWS_PROFILE_MY_PROFILE=my_profile
        If no env file is present, the default file will be generated
        AWS_PROFILE_DEFAULT=default
        """,
    )
    parsed_args = args.parse_args(args_in)
    return parsed_args


@typechecked
def ensure_env_file(env_template: str, env_file: str) -> None:
    if env_file and not os.path.exists(env_file):
        shutil.copy(env_template, env_file)


@typechecked
def get_child_dirs(rel_path: str) -> List[str]:
    child_dirs = sorted(
        [
            child_dir
            for child_dir in os.listdir(rel_path)
            if os.path.isdir(os.path.join(rel_path, child_dir))
        ]
    )
    return child_dirs


@typechecked
def get_app_dir_conf(
    tf_root: str, provisioning_dir: str, dir_data: Dict, app_dirs: Dict
) -> None:
    app_conf = dir_data.get("app", {})
    skip_dirs = dir_data.get("skip_plan", [])
    for app_dir in get_child_dirs(os.path.join(tf_root, provisioning_dir)):
        app_data = app_conf.get(app_dir, {})
        app_dirs[f"{provisioning_dir}_{app_dir}"] = {
            "path": os.path.join(tf_root, provisioning_dir, app_dir),
            "aws_profile": f"AWS_PROFILE_{dir_data['aws_profile']}",
            "skip_plan": app_dir in skip_dirs,
            "var_file": app_data.get("var_file", None),
        }


@typechecked
def get_mod_dirs(
    parent_dir: str,
    curr_dir: str,
    module_postfixes: List[str],
    module_ignore_postfixes: List[str],
    all_mod_dirs: List[str],
) -> None:
    """Recursively search for module directories"""
    if any(curr_dir.endswith(postfix) for postfix in module_ignore_postfixes):
        return
    rel_dir = os.path.join(parent_dir, curr_dir)
    if any(parent_dir.endswith(parent) for parent in module_postfixes):
        all_mod_dirs.append(rel_dir)
    child_dirs = get_child_dirs(rel_dir)
    child_mods = []
    for child_dir in child_dirs:
        get_mod_dirs(
            rel_dir, child_dir, module_postfixes, module_ignore_postfixes, child_mods
        )
    all_mod_dirs.extend(child_mods)


@typechecked
def render_makefile(
    template: str, makefile: str, app_dir_to_conf_data: Dict, all_mod_dirs: List
) -> None:
    make_template = jinja_env.get_template(template)
    makefile_content = make_template.render(
        app_dirs=app_dir_to_conf_data, mod_dirs=all_mod_dirs
    )
    makefile_content = f"{makefile_content}\n"
    with open(makefile, "w") as f:
        f.write(makefile_content)


@typechecked
def render_makefile_and_env(
    template: str,
    makefile: str,
    module_root: str,
    module_postfixes: List[str],  # type: ignore
    module_ignore_postfixes: List[str],
    tf_root: str,
    env_template: str,
    env_file: str,
    provisioning_directories: str,  # type: ignore
) -> None:
    provisioning_directories: Dict[str, Any] = json.loads(provisioning_directories)
    ensure_env_file(env_template, env_file)
    app_dir_to_conf_data = {}
    for provisioning_dir, dir_data in provisioning_directories.items():
        get_app_dir_conf(tf_root, provisioning_dir, dir_data, app_dir_to_conf_data)
    all_mod_dirs = []
    get_mod_dirs(
        "", module_root, module_postfixes, module_ignore_postfixes, all_mod_dirs
    )
    render_makefile(template, makefile, app_dir_to_conf_data, all_mod_dirs)


@typechecked
def main(args_in: Optional[List[str]] = None) -> None:
    args = parse_args(args_in)
    render_makefile_and_env(**vars(args))


if __name__ == "__main__":
    main()
