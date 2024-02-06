"""
This script formats all JSON in a directory recursively.
It is used to format generated config files automatically after apply.
"""
import json
import os
import shutil

from typeguard import typechecked


@typechecked
def format_json(file_path: str) -> None:
    try:
        with open(file_path) as f:
            content = json.load(f)
        with open(file_path, "w") as f:
            json.dump(content, f, indent="  ")
            f.write("\n")
    except Exception as e:
        print(f"Error formatting {file_path}:\n{e}")


@typechecked
def format_dir(dir_path: str) -> None:
    file_names = sorted(os.listdir(dir_path))
    for file_name in file_names:
        file_path = os.path.join(dir_path, file_name)
        if os.path.isfile(file_path):
            if file_name.endswith(".raw.json"):
                print(f"  Copying and formatting {file_path}")
                formatted_path = file_path.replace(".raw.json", ".json")
                shutil.copyfile(file_path, formatted_path)
                format_json(formatted_path)
            elif file_name.endswith(".json"):
                raw_path = file_path.replace(".json", ".raw.json")
                if os.path.exists(raw_path):
                    print(f"  Skipping {file_path}")
                else:
                    format_json(file_path)
        elif os.path.isdir(file_path) and not any(
            tag in file_name for tag in ["cache", ".git", "venv"]
        ):
            format_dir(file_path)


def main() -> None:
    root_path = os.path.abspath(".")
    print(f"Formatting JSON in {root_path}")
    format_dir(root_path)


if __name__ == "__main__":
    main()
