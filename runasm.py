#!/usr/bin/env python3

import argparse
import subprocess
import sys
from pathlib import Path


def run(cmd):
    print("+", " ".join(map(str, cmd)))
    subprocess.run(cmd, check=True)


def main():
    parser = argparse.ArgumentParser(
        description="Assemble and run NASM x86-64 programs"
    )
    parser.add_argument("file", help="NASM source file")
    parser.add_argument(
        "-d", "--debug", action="store_true", help="run under gdb/pwndbg"
    )
    parser.add_argument(
        "-k", "--keep", action="store_true", help="keep object/executable files"
    )
    parser.add_argument("--no-run", action="store_true", help="build only")
    parser.add_argument(
        "--start", action="store_true", help="link as raw _start program"
    )
    args = parser.parse_args()

    asm_path = Path(args.file).resolve()

    if not asm_path.exists():
        print(f"error: file not found: {asm_path}", file=sys.stderr)
        sys.exit(1)

    base = asm_path.with_suffix("")
    obj_path = base.with_suffix(".o")
    exe_path = base

    nasm_cmd = [
        "nasm",
        "-f",
        "elf64",
        "-g",
        "-F",
        "dwarf",
        str(asm_path),
        "-o",
        str(obj_path),
    ]

    if args.start:
        link_cmd = [
            "gcc",
            "-nostdlib",
            "-g",
            "-no-pie",
            str(obj_path),
            "-o",
            str(exe_path),
        ]
    else:
        link_cmd = [
            "gcc",
            "-g",
            "-O0",
            "-no-pie",
            str(obj_path),
            "-o",
            str(exe_path),
        ]

    try:
        run(nasm_cmd)
        run(link_cmd)

        if args.no_run:
            return

        if args.debug:
            gdb_cmd = [
                "pwndbg",
                "-q",
                str(exe_path.resolve()),
                "-ex",
                "set disassembly-flavor intel",
                "-ex",
                "break main" if not args.start else "break _start",
                "-ex",
                "run",
            ]
            run(gdb_cmd)
        else:
            run([str(exe_path.resolve())])

    finally:
        if not args.keep:
            if obj_path.exists():
                obj_path.unlink()

            # Keep executable after debugging so it can be reopened manually.
            if exe_path.exists() and not args.debug:
                exe_path.unlink()


if __name__ == "__main__":
    main()
