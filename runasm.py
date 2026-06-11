#!/usr/bin/env python3

import argparse
import subprocess
from pathlib import Path


def run(cmd: list[str]) -> None:
    print("+", " ".join(cmd))
    subprocess.run(cmd, check=True)


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Assemble, link, and run a NASM x86-64 assembly file."
    )
    parser.add_argument("source", help="Assembly source file, e.g. qsort_example.asm")
    parser.add_argument(
        "--no-run",
        action="store_true",
        help="Build only; do not run the executable.",
    )
    parser.add_argument(
        "--pie",
        action="store_true",
        help="Link as PIE. By default, uses gcc -no-pie.",
    )
    parser.add_argument(
        "--build-dir",
        default="build",
        help="Directory for object files and executables. Default: build",
    )

    args = parser.parse_args()

    src = Path(args.source)

    if not src.is_file():
        print(f"Error: file not found: {src}")
        return 1

    build_dir = Path(args.build_dir)
    build_dir.mkdir(parents=True, exist_ok=True)

    name = src.stem
    obj = build_dir / f"{name}.o"
    exe = build_dir / name

    nasm_cmd = [
        "nasm",
        "-f",
        "elf64",
        str(src),
        "-o",
        str(obj),
    ]

    gcc_cmd = [
        "gcc",
    ]

    if not args.pie:
        gcc_cmd.append("-no-pie")

    gcc_cmd += [
        str(obj),
        "-o",
        str(exe),
    ]

    try:
        run(nasm_cmd)
        run(gcc_cmd)

        if not args.no_run:
            run([str(exe)])

    except subprocess.CalledProcessError as e:
        print(f"Command failed with exit code {e.returncode}")
        return e.returncode

    return 0


if __name__ == "__main__":
    raise SystemExit(main())