"""Check tracked shell files individually, including dotfile entry points."""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[2]


def main():
    files = subprocess.check_output(
        ["git", "ls-files", "-z"], cwd=ROOT, text=True,
    ).split("\0")
    for name in files:
        path = ROOT / name
        if not path.is_file():
            continue
        if name in (".zprofile", ".zshenv", ".zshrc") or name.endswith(".zsh"):
            commands = [["zsh", "-n", name]]
        elif (name in (".bash_profile", ".bashrc", "sh/env", ".githooks/pre-commit")
              or name.endswith(".sh") or path.read_bytes().startswith(b"#!/usr/bin/env bash")):
            commands = [["bash", "-n", name], ["shellcheck", "--shell=bash", name],
                        ["shfmt", "-d", "-i", "4", "-ci", name]]
        else:
            continue
        for command in commands:
            subprocess.run(command, cwd=ROOT, check=True, timeout=30)


if __name__ == "__main__":
    main()
