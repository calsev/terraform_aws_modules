"""Build a Python Lambda layer from pip requirements.

Terraform runs this two ways:

- `platform`, as a `data "external"` program at plan time: reads the layer's
  runtime, architecture and optional platform override as JSON on stdin and prints
  the Python version and the ordered pip platform tags to install for.
- `build`, as a `local-exec` provisioner at apply time: takes one JSON argument and
  resolves dependencies for the target with Pex, pip-installs the resolved wheels
  into `python/`, then writes the layer zip.

Planning uses only the standard library. Applying needs pip and the pinned Pex and
packaging packages in the supplied interpreter; a separate target Python installation
is not needed. Dependency markers describe the target, never this interpreter's host.
"""

import importlib.metadata
import json
import os
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile
import typing
import zipfile

ARCHITECTURE_TO_PIP_ARCH = {
    "arm64": "aarch64",
    "x86_64": "x86_64",
}

# The oldest glibc minor that has manylinux wheels for each architecture
GLIBC_MINOR_FLOOR = {
    "aarch64": 17,
    "x86_64": 5,
}

# Legacy aliases (PEP 600) and the glibc minor each is equivalent to
LEGACY_ALIAS_TO_GLIBC_MINOR = {
    "manylinux2014": 17,
    "manylinux2010": 12,
    "manylinux1": 5,
}

# Runtimes on Amazon Linux 2023 (glibc 2.34); older Python runtimes are on Amazon Linux 2
AL2023_FIRST_PYTHON_MINOR = 12
GLIBC_MINOR_AL2 = 17  # manylinux2014; AWS's documented target for Amazon Linux 2
GLIBC_MINOR_AL2023 = 34

PEP_600_PATTERN = re.compile(r"^manylinux_2_(\d+)_(\w+)$")
LEGACY_PATTERN = re.compile(r"^(manylinux2014|manylinux2010|manylinux1)_(\w+)$")
RUNTIME_PATTERN = re.compile(r"^python3\.(\d+)$")

# A fixed timestamp keeps the zip identical for identical content
ZIP_DATE_TIME = (1980, 1, 1, 0, 0, 0)

# This is a build input through Terraform's hash of this script. Pin the resolver
# so different applying machines use the same resolution behavior.
PEX_VERSION = "2.107.1"
PACKAGING_VERSION = "26.3"


def python_minor(runtime: str) -> int:
    match = RUNTIME_PATTERN.match(runtime)
    if match is None:
        raise ValueError(f"Not a Python 3 Lambda runtime: {runtime}")
    return int(match.group(1))


def pip_arch(architecture: str) -> str:
    if architecture not in ARCHITECTURE_TO_PIP_ARCH:
        raise ValueError(
            f"Unsupported architecture {architecture}, expected one of {sorted(ARCHITECTURE_TO_PIP_ARCH)}"
        )
    return ARCHITECTURE_TO_PIP_ARCH[architecture]


def runtime_glibc_minor(runtime: str) -> int:
    if python_minor(runtime) >= AL2023_FIRST_PYTHON_MINOR:
        return GLIBC_MINOR_AL2023
    return GLIBC_MINOR_AL2


def manylinux_platform_list(glibc_minor: int, arch: str) -> list[str]:
    """Every manylinux tag a glibc 2.<glibc_minor> system accepts, most preferred first.

    pip does not expand an explicit PEP 600 tag to older ones, so each is passed.
    """
    floor = GLIBC_MINOR_FLOOR[arch]
    if glibc_minor < floor:
        raise ValueError(f"No manylinux tags for {arch} below glibc 2.{floor}")
    alias_by_minor = {
        minor: alias for alias, minor in LEGACY_ALIAS_TO_GLIBC_MINOR.items()
    }
    platform_list: list[str] = []
    for minor in range(glibc_minor, floor - 1, -1):
        platform_list.append(f"manylinux_2_{minor}_{arch}")
        if minor in alias_by_minor:
            platform_list.append(f"{alias_by_minor[minor]}_{arch}")
    return platform_list


def effective_platform_list(
    runtime: str,
    architecture: str,
    pip_platform: str | None,
) -> list[str]:
    """The pip platforms for a layer: derived from the runtime, or from an override.

    A manylinux override (PEP 600 or legacy) sets the glibc ceiling and is expanded
    like the derived one; any other override is passed to pip as is.
    """
    arch = pip_arch(architecture)
    python_minor(runtime)  # Validate
    if not pip_platform:
        return manylinux_platform_list(runtime_glibc_minor(runtime), arch)
    pep_600_match = PEP_600_PATTERN.match(pip_platform)
    legacy_match = LEGACY_PATTERN.match(pip_platform)
    if pep_600_match is not None:
        glibc_minor, override_arch = int(pep_600_match.group(1)), pep_600_match.group(2)
    elif legacy_match is not None:
        glibc_minor = LEGACY_ALIAS_TO_GLIBC_MINOR[legacy_match.group(1)]
        override_arch = legacy_match.group(2)
    else:
        return [pip_platform]
    if override_arch != arch:
        raise ValueError(
            f"Platform {pip_platform} does not match architecture {architecture} ({arch})"
        )
    return manylinux_platform_list(glibc_minor, arch)


def platform_result(query: dict[str, str]) -> dict[str, str]:
    """The `data "external"` result: a flat map of strings"""
    runtime = query["runtime"]
    platform_list = effective_platform_list(
        runtime=runtime,
        architecture=query["architecture"],
        pip_platform=query.get("pip_platform") or None,
    )
    return {
        "platform_list_json": json.dumps(platform_list),
        "python_version": f"3.{python_minor(runtime)}",
    }


def cpython_abi(python_version: str) -> str:
    major, minor = (int(part) for part in python_version.split("."))
    return f"cp{major}{minor}" + ("m" if (major, minor) < (3, 8) else "")


def pip_install_args(
    python_version: str,
    platform_list: list[str],
    requirements_path: str,
    target_dir: str,
) -> list[str]:
    args = [
        sys.executable,
        "-m",
        "pip",
        "install",
        "--disable-pip-version-check",
        "--no-compile",  # Lambda cannot write bytecode next to the layer
        "--only-binary=:all:",
        "--no-deps",  # Pex already resolved the complete target dependency graph
        "--abi",
        cpython_abi(python_version),
        "--implementation",
        "cp",
        "--python-version",
        python_version,
    ]
    for platform in platform_list:
        args.extend(["--platform", platform])
    args.extend(["--target", target_dir])
    args.extend(["--requirement", requirements_path])
    return args


def complete_platform(
    architecture: str, platform_list: list[str], python_version: str
) -> dict[str, typing.Any]:
    """Pex's explicit marker environment and complete ordered wheel compatibility."""
    # Imported only at apply: planning has no dependencies beyond the standard library.
    from packaging import tags

    major, minor = (int(part) for part in python_version.split("."))
    version = (major, minor)
    interpreter = f"cp{major}{minor}"
    abi = cpython_abi(python_version)
    compatible = [
        *tags.cpython_tags(python_version=version, abis=[abi], platforms=platform_list),
        *tags.compatible_tags(
            python_version=version, interpreter=interpreter, platforms=platform_list
        ),
    ]
    return {
        "marker_environment": {
            "implementation_name": "cpython",
            # A minor runtime input has the same X.Y.0 baseline as pip's
            # --python-version X.Y, independent of the applying interpreter.
            "implementation_version": f"{python_version}.0",
            "os_name": "posix",
            "platform_machine": pip_arch(architecture),
            "platform_python_implementation": "CPython",
            "platform_system": "Linux",
            "python_full_version": f"{python_version}.0",
            "python_version": python_version,
            "sys_platform": "linux",
        },
        "compatible_tags": list(dict.fromkeys(str(tag) for tag in compatible)),
    }


def resolve_requirements(
    architecture: str,
    python_version: str,
    platform_list: list[str],
    requirement_list: list[str],
    work_dir: pathlib.Path,
) -> pathlib.Path:
    """Resolve and strip markers for the target before pip sees requirements.

    pip's --python-version/--platform affect wheel tags, not PEP 508 markers.
    Pex evaluates markers and selects wheels for a complete platform, including
    custom platform overrides. Export a pinned requirements file with artifact
    hashes but no markers or extras; pip installs it without resolving again.
    """
    for package, version in [("pex", PEX_VERSION), ("packaging", PACKAGING_VERSION)]:
        try:
            installed_version = importlib.metadata.version(package)
        except importlib.metadata.PackageNotFoundError:
            installed_version = None
        if installed_version != version:
            raise RuntimeError(
                f"Layer builds need {package}=={version} in {sys.executable}; "
                f"install it with {sys.executable} -m pip install {package}=={version}"
            )
    requirements_in = work_dir / "requirements.in"
    requirements_in.write_text("\n".join(requirement_list) + "\n", encoding="utf-8")
    requirements_out = work_dir / "requirements.txt"
    platform_path = work_dir / "platform.json"
    platform_path.write_text(
        json.dumps(complete_platform(architecture, platform_list, python_version)),
        encoding="utf-8",
    )
    lock_path = work_dir / "lock.json"
    command = [sys.executable, "-m", "pex.cli", "lock"]
    # Keep the resolver's bootstrap state and cache in this build directory too.
    env = {**os.environ, "PEX_ROOT": str(work_dir / "pex")}
    subprocess.run(
        [
            *command,
            "create",
            "--complete-platform",
            str(platform_path),
            "--no-build",
            "--pip-version",
            "26.3",
            "--no-allow-pip-version-fallback",
            "--use-pip-config",
            "--requirement",
            str(requirements_in),
            "--output",
            str(lock_path),
        ],
        check=True,
        env=env,
    )
    subprocess.run(
        [
            *command,
            "export",
            "--complete-platform",
            str(platform_path),
            "--format",
            "pip",
            "--output",
            str(requirements_out),
            str(lock_path),
        ],
        check=True,
        env=env,
    )
    return requirements_out


def write_zip(content_dir: pathlib.Path, zip_path: pathlib.Path) -> None:
    """Zip a directory with sorted entries and fixed timestamps"""
    file_list = sorted(path for path in content_dir.rglob("*") if path.is_file())
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for path in file_list:
            info = zipfile.ZipInfo(
                path.relative_to(content_dir).as_posix(), date_time=ZIP_DATE_TIME
            )
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o755 if os.access(path, os.X_OK) else 0o644) << 16
            archive.writestr(info, path.read_bytes())


def build(spec: dict[str, typing.Any]) -> None:
    zip_path = pathlib.Path(spec["zip_path"]).resolve()
    zip_path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(dir=zip_path.parent) as work_dir:
        work_path = pathlib.Path(work_dir)
        requirements_path = resolve_requirements(
            architecture=spec["architecture"],
            python_version=spec["python_version"],
            platform_list=spec["platform_list"],
            requirement_list=spec["requirement_list"],
            work_dir=work_path,
        )
        content_dir = work_path / "content"
        args = pip_install_args(
            python_version=spec["python_version"],
            platform_list=spec["platform_list"],
            requirements_path=str(requirements_path),
            target_dir=str(content_dir / "python"),
        )
        print(" ".join(args), flush=True)
        subprocess.run(args, check=True)
        partial_path = pathlib.Path(work_dir) / zip_path.name
        write_zip(content_dir, partial_path)
        shutil.move(
            partial_path, zip_path
        )  # Never leave a partial zip at the final path
    print(f"Wrote {zip_path}", flush=True)


def main(argv: list[str]) -> None:
    if len(argv) >= 2 and argv[1] == "platform":
        query = typing.cast(dict[str, str], json.load(sys.stdin))
        json.dump(platform_result(query), sys.stdout)
    elif len(argv) == 3 and argv[1] == "build":
        build(typing.cast(dict[str, typing.Any], json.loads(argv[2])))
    else:
        raise SystemExit(f"Usage: {argv[0]} platform < query.json | build <spec json>")


if __name__ == "__main__":
    main(sys.argv)
