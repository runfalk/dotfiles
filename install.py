#!/usr/bin/env python3
import argparse
from pathlib import Path
from itertools import zip_longest
from subprocess import check_output


script_dir = Path(__file__).resolve().parent


def num_common_parts(a, b):
    for i, (x, y) in enumerate(zip_longest(a.parts, b.parts)):
        if x != y:
            return i
    return len(a.parts)


def relative_to(a, b):
    # Like Path.relative_to(), but supports ancestors
    num_common = num_common_parts(a, b)
    parts = [".."] * (len(b.parts) - num_common)
    parts.extend(a.parts[num_common:])
    return Path(*parts)


def confirm(prompt, *, default):
    while True:
        yn = input(prompt)
        if not yn:
            yn = "y" if default else "n"
        if yn.lower() in ("y", "n"):
            return yn.lower() == "y"


def install_pkg(pkg_path, *, overwrite=False):
    setup_path = pkg_path.joinpath("dotfile_setup")

    for path in pkg_path.glob("**/*"):
        if path.is_dir() or path == setup_path:
            continue

        rel_path = path.relative_to(pkg_path)
        link_path = Path.home() / rel_path
        link_target = relative_to(path, link_path.parent)

        if not link_path.parent.is_dir():
            link_path.parent.mkdir(parents=True, exist_ok=True)

        if (
            link_path.exists()
            and not link_path.is_symlink()
            and not overwrite
            and not confirm(
                f"File {link_path} already exists, delete it? [Y/n] ",
                default=True,
            )
        ):
            continue
        link_path.unlink(missing_ok=True)
        link_path.symlink_to(link_target)

    if setup_path.exists():
        check_output([str(setup_path)])


def main():
    parser = argparse.ArgumentParser(description="Install dotfiles")
    parser.add_argument(
        "package",
        nargs="*",
        help="packages to install (leave empty to install all)",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="accept all yes prompts",
    )
    cfg = parser.parse_args()

    packages = {
        d for d in script_dir.iterdir()
        if d.is_dir() and d.name != ".git"
    }

    if cfg.package:
        packages = {p for p in packages if p.name in cfg.package}
        if len(packages) != len(cfg.package):
            unknown_packages = set(cfg.package) - {p.name for p in packages}
            print(f"Unknown package(s): {', '.join(unknown_packages)}")
            exit(1)
    elif not cfg.yes and not confirm("Install all packages? [Y/n]", default=True):
        exit(0)
    
    for p in packages:
        install_pkg(p, overwrite=cfg.yes)
        print(f"installed {p.name}")


if __name__ == "__main__":
    main()
