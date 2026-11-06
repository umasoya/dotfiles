"""Install the real Nix profile; isolate deployment and mock GUI installation."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]


def main():
    with tempfile.TemporaryDirectory(prefix="dotfiles-ci-") as temporary:
        base = Path(temporary).resolve()
        home = base / "home with spaces"
        home.mkdir()
        checkout = home / "dotfiles"
        # Copy tracked content only: no credentials, local settings, or Git metadata.
        files = subprocess.check_output(
            ["git", "ls-files", "-z"], cwd=ROOT, text=True,
        ).split("\0")
        for name in filter(None, files):
            destination = checkout / name
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / name, destination, follow_symlinks=False)
        # Give Nix a self-contained Git source, independent of parent repositories.
        subprocess.run(["git", "init", str(checkout)], check=True, timeout=30)
        subprocess.run(["git", "-C", str(checkout), "add", "."], check=True, timeout=30)
        mock_bin = base / "bin"
        mock_bin.mkdir()
        brew = mock_bin / "brew"
        brew.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$HOME/brew-calls"\n')
        brew.chmod(0o755)
        env = dict(os.environ)
        # Avoid inherited user configuration and any already-installed dotfiles profile.
        for key in ("XDG_CONFIG_HOME", "XDG_STATE_HOME", "XDG_CACHE_HOME", "CODEX_HOME",
                    "ZDOTDIR", "DOT_DIR", "NIX_PROFILES", "NIX_USER_PROFILE_DIR"):
            env.pop(key, None)
        env.update(HOME=str(home), PATH=f"{mock_bin}:{env['PATH']}", DOT_DIR=str(checkout))
        profile = home / ".local/state/nix/profiles/dotfiles"

        def run(*command):
            return subprocess.run(command, cwd=home, env=env, check=True, timeout=900)

        run("bash", str(checkout / "init.sh"), "--dry-run")
        assert not profile.exists(), "dry-run installed a profile"
        assert not (home / ".bashrc").exists(), "dry-run deployed settings"
        run("bash", str(checkout / "init.sh"))
        generation = profile.resolve(strict=True)
        for name in ("git", "nvim", "zsh", "rg", "shellcheck", "codex", "claude", "herdr"):
            assert (profile / "bin" / name).is_file(), f"Missing CLI: {name}"
        for name in (".bashrc", ".zshrc", ".gitconfig"):
            assert (home / name).is_symlink(), f"Missing deployment: {name}"
        run("bash", str(checkout / "init.sh"))
        assert profile.resolve(strict=True) == generation, "Rerun replaced the profile"
        run(str(profile / "bin/bash"), "-lc", 'test "$EDITOR" = nvim && command -v rg')
        run(str(profile / "bin/zsh"), "-lic", 'test "$EDITOR" = nvim && command -v rg')
        if os.uname().sysname == "Darwin":
            assert (home / "brew-calls").read_text().count("bundle --file=") == 2


if __name__ == "__main__":
    main()
