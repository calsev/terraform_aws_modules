import os
import shutil

import typer

TEMPLATE_DIR = "development/modules"


def copy_all_modules() -> None:
    module_dirs = sorted(
        dir
        for dir in os.listdir(".")
        if os.path.isdir(dir) and dir not in ["documentation", "development", ".git"]
    )
    for module_dir in module_dirs:
        for root, _, files in os.walk(module_dir):
            for file in sorted(files):
                if file.endswith(".tf"):
                    rel_path = os.path.relpath(os.path.join(root, file), start=".")
                    output_path = f"{os.path.join(TEMPLATE_DIR, rel_path)[:-3]}.in.tf"
                    if os.path.exists(output_path):
                        continue
                    os.makedirs(os.path.dirname(output_path), exist_ok=True)
                    shutil.copy2(rel_path, output_path)
                    print(f"Copied {rel_path} -> {output_path}")


def main() -> None:
    copy_all_modules(**locals())


if __name__ == "__main__":
    typer.run(main)
