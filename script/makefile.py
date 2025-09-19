"""Generate a Makefile with targets for each stack because they are very repetitive"""

import json
import os
import typing

import jinja2
import typer

jinja_loader = jinja2.FileSystemLoader(searchpath=".")
jinja_env = jinja2.Environment(loader=jinja_loader)


def profile(app_data: dict[str, typing.Any]):
    return f"AWS_PROFILE=$${app_data['aws_profile']} GITHUB_TOKEN=$$GITHUB_TOKEN_{app_data['github_profile']}"


jinja_env.filters["profile"] = profile


def get_child_dirs(rel_path: str) -> list[str]:
    child_dirs = sorted(
        [
            child_dir
            for child_dir in os.listdir(rel_path)
            if os.path.isdir(os.path.join(rel_path, child_dir))
        ]
    )
    return child_dirs


def get_app_dir_conf(
    tf_root: str,
    prov_dir: str,
    dir_data: dict[str, typing.Any],
    prov_dirs: dict[str, dict[str, typing.Any]],
    app_dirs: dict[str, typing.Any],
) -> None:
    app_conf = dir_data.get("app", {})
    skip_dirs = dir_data.get("skip_plan", [])
    for app_dir in get_child_dirs(os.path.join(tf_root, prov_dir)):
        app_data = app_conf.get(app_dir, {})
        curr_dir_data = {
            "path": os.path.join(tf_root, prov_dir, app_dir),
            "aws_profile": f"AWS_PROFILE_{dir_data['aws_profile']}",
            "github_profile": dir_data["github_profile"],
            "skip_plan": app_dir in skip_dirs,
            "var_file": app_data.get("var_file", None),
        }
        if prov_dir not in prov_dirs:
            prov_dirs[prov_dir] = {}
        prov_dirs[prov_dir][app_dir] = curr_dir_data
        app_dirs[f"{prov_dir}_{app_dir}"] = curr_dir_data


def get_mod_dirs(
    parent_dir: str,
    curr_dir: str,
    module_ignore_postfixes: list[str],
    all_mod_dirs: list[str],
) -> None:
    """Recursively search for module directories"""
    if any(curr_dir.endswith(postfix) for postfix in module_ignore_postfixes):
        return
    rel_dir = os.path.join(parent_dir, curr_dir)
    if not rel_dir.endswith(".."):
        all_mod_dirs.append(rel_dir)
    child_dirs = get_child_dirs(rel_dir)
    child_mods: list[str] = []
    for child_dir in child_dirs:
        get_mod_dirs(rel_dir, child_dir, module_ignore_postfixes, child_mods)
    all_mod_dirs.extend(child_mods)


def render_makefile(
    template: str,
    makefile: str,
    provisioning_dir_to_app_dir_to_conf_data: dict[str, dict[str, typing.Any]],
    app_dir_to_conf_data: dict[str, typing.Any],
    all_mod_dirs: list[str],
) -> None:
    make_template = jinja_env.get_template(template)
    makefile_content = make_template.render(
        prov_dirs=provisioning_dir_to_app_dir_to_conf_data,
        app_dirs=app_dir_to_conf_data,
        mod_dirs=all_mod_dirs,
    )
    makefile_content = f"{makefile_content}\n"
    with open(makefile, "w") as f:
        f.write(makefile_content)


def render_makefile_and_env(
    template: str,
    makefile: str,
    module_root: str,
    module_ignore_postfixes: str,
    tf_root: str,
    directory_defaults: str,
    provisioning_directories: str,
) -> None:
    dir_default: dict[str, typing.Any] = json.loads(directory_defaults)
    provisioning_dirs: dict[str, typing.Any] = json.loads(provisioning_directories)
    module_ignore_post: list[str] = json.loads(module_ignore_postfixes)
    provisioning_dir_to_app_dir_to_conf_data: dict[str, dict[str, typing.Any]] = {}
    app_dir_to_conf_data: dict[str, typing.Any] = {}
    for provisioning_dir, dir_data in provisioning_dirs.items():
        effective_dir: dict[str, typing.Any] = {
            **dir_default,
            **dir_data,
        }
        get_app_dir_conf(
            tf_root,
            provisioning_dir,
            effective_dir,
            provisioning_dir_to_app_dir_to_conf_data,
            app_dir_to_conf_data,
        )
    all_mod_dirs: list[str] = []
    get_mod_dirs("", module_root, module_ignore_post, all_mod_dirs)
    render_makefile(
        template,
        makefile,
        provisioning_dir_to_app_dir_to_conf_data,
        app_dir_to_conf_data,
        all_mod_dirs,
    )


def main(
    template: str = typer.Option(
        "in.Makefile",
        help="Relative path to the Makefile template to render",
    ),
    makefile: str = typer.Option(
        "Makefile",
        help="Relative path to the makefile",
    ),
    module_root: str = typer.Option(
        "modules",
        help="Relative path to the module root",
    ),
    module_ignore_postfixes: str = typer.Option(
        "[]",
        help="JSON array of filters for parent subdirectories directories to ignore",
    ),
    tf_root: str = typer.Option(
        "stack",
        help="Relative path to the root of Terraform stacks",
    ),
    directory_defaults: str = typer.Argument(
        "stack",
        help="""
        A JSON object containing defaults for provisioning directories. For example:
        {
          "aws_profile": "MY_PROFILE",
          "github_profile": "MY_PROFILE"
        }
        """,
    ),
    provisioning_directories: str = typer.Argument(
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
            "github_profile": "MY_PROFILE",
            "skip_plan": [
              "obsolete_app"
            ]
          },
          "stack2": {}
        }
        AWS profiles are common to the repo and mapped in an env file, e.g.
        AWS_PROFILE_MY_PROFILE=my_profile
        """,
    ),
) -> None:
    render_makefile_and_env(**locals())


if __name__ == "__main__":
    typer.run(main)
