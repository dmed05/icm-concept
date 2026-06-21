#!/usr/bin/env python3
"""Create an independent ICM project workspace from the clean template."""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


PLACEHOLDERS = {
    "{{PROJECT_PURPOSE}}": "Define the repeatable outcome for this project.",
    "{{STAGE_MAP}}": "No project stages have been configured yet.",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create a new ICM workspace without modifying the builder."
    )
    parser.add_argument("project_name", help="Human-readable project name")
    parser.add_argument("destination", type=Path, help="New workspace directory")
    return parser.parse_args()


def replace_placeholders(root: Path, project_name: str) -> None:
    replacements = {"{{PROJECT_NAME}}": project_name, **PLACEHOLDERS}
    for path in root.rglob("*.md"):
        text = path.read_text(encoding="utf-8")
        for placeholder, value in replacements.items():
            text = text.replace(placeholder, value)
        path.write_text(text, encoding="utf-8")


def main() -> int:
    args = parse_args()
    builder_root = Path(__file__).resolve().parent.parent
    template = builder_root / "workspace-template"
    destination = args.destination.expanduser().resolve()

    if not template.is_dir():
        print(f"Template not found: {template}", file=sys.stderr)
        return 1

    if destination == builder_root or builder_root in destination.parents:
        print(
            "Destination must be outside the builder workspace.",
            file=sys.stderr,
        )
        return 2

    if destination.exists() and any(destination.iterdir()):
        print(f"Destination is not empty: {destination}", file=sys.stderr)
        return 3

    if destination.exists():
        destination.rmdir()

    shutil.copytree(template, destination)
    replace_placeholders(destination, args.project_name)
    print(destination)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
