import os
import pathlib
import shutil

import jinja2
import typer

FRAGMENT_DIR = "development/module_fragments"
TEMPLATE_DIR = "development/modules"

loader = jinja2.FileSystemLoader(searchpath=".")
env = jinja2.Environment(loader=loader)


def conditional_lines(lines: list[tuple[str, bool]], **kwargs):
    return "\n".join(
        jinja2.Template(line).render(**kwargs) for line, include in lines if include
    )


env.filters["conditional_lines"] = conditional_lines


def tf_list(items: list[str], indent=2) -> str:
    indent_space = "  " * indent
    bracket_space = "  " * (indent - 1)
    if not items:
        return "[]"
    return (
        "[\n"
        + "".join(f'{indent_space}"{item}",\n' for item in items)
        + f"{bracket_space}]"
    )


env.filters["tf_list"] = tf_list


def discover_fragment_names() -> list[str]:
    names = []
    for root, _, files in os.walk(FRAGMENT_DIR):
        for file in files:
            if file.endswith(".tf.in"):
                rel_path = os.path.relpath(os.path.join(root, file), FRAGMENT_DIR)
                names.append(rel_path[:-6].replace(os.sep, "_"))  # Strip `.tf.in`
    return names


def macro_imports() -> str:
    fragment_names = discover_fragment_names()
    import_lines = [
        f'{{% import "{FRAGMENT_DIR}/{frag}.tf.in" as {frag} %}}'
        for frag in fragment_names
    ]
    return "".join(import_lines)


def inject_imports_and_sanitize_content(
    global_import_str: str, raw_content: str
) -> str:
    safe_content = f"{global_import_str}{raw_content}"
    # Escape AWS templates
    safe_content = safe_content.replace("{##", "{% raw %}{##")
    safe_content = safe_content.replace("##}", "##}{% endraw %}")
    return safe_content


def compute_module_up(template_file: str) -> str:
    # Count how many path segments exist in the path relative to TEMPLATE_DIR
    rel_parts = pathlib.Path(template_file).parent.parts
    depth = len(rel_parts)
    return "/".join(".." for _ in range(depth)) or "."


def render_one_tf_module(global_import_str: str, template_file: str) -> str:
    with open(os.path.join(TEMPLATE_DIR, template_file), "r") as f:
        raw_content = f.read()
    safe_content = inject_imports_and_sanitize_content(
        global_import_str=global_import_str,
        raw_content=raw_content,
    )

    try:
        template = env.from_string(safe_content)
    except jinja2.exceptions.TemplateSyntaxError:
        print(safe_content)  # Display template to make debugging easier
        raise

    module_up = compute_module_up(template_file)
    template.globals["module_up"] = module_up
    print(
        f"Rendering template {template_file} with module_up = {module_up} and {template.globals['module_up']}"
    )

    rendered = template.render()
    return f"{rendered}\n" if rendered else ""


def ensure_all_files(root: str, files: list[str]) -> None:
    # Copy standard files if missing
    for std_file in ["outputs", "versions"]:
        if files and f"{std_file}.tf.in" not in files:
            src_path = os.path.join(FRAGMENT_DIR, f"{std_file}.tf")
            rel_dir = os.path.relpath(root, TEMPLATE_DIR)
            dst_path = os.path.join(rel_dir, f"{std_file}.tf")
            print(f"Copying {std_file}.tf -> {dst_path}")
            shutil.copy2(src_path, dst_path)


def render_all_tf_modules() -> None:
    global_import_str = macro_imports()
    for module_dir in sorted(os.listdir(TEMPLATE_DIR)):
        abs_module_path = os.path.join(TEMPLATE_DIR, module_dir)
        if not os.path.isdir(abs_module_path) or module_dir.startswith("."):
            continue

        file_list = [(root, files) for root, _, files in os.walk(abs_module_path)]
        file_list.sort(key=lambda _: 0)
        for root, files in file_list:
            for file in sorted(files):
                if file.endswith(".tf.in"):
                    abs_path = os.path.join(root, file)
                    rel_path = os.path.relpath(abs_path, TEMPLATE_DIR)
                    # if file == "outputs.tf.in":
                    #     os.remove(os.path.join(TEMPLATE_DIR, rel_path))
                    #     continue
                    output_path = rel_path[:-6] + ".tf"  # Strip `.tf.in`
                    rendered = render_one_tf_module(global_import_str, rel_path)
                    os.makedirs(os.path.dirname(output_path), exist_ok=True)
                    with open(output_path, "w") as f:
                        f.write(rendered)
            ensure_all_files(root, files)


def main() -> None:
    render_all_tf_modules()


if __name__ == "__main__":
    typer.run(main)
