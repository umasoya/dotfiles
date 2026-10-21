"""Run the raw-script entry point through stdin with an isolated home and Git."""
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class BootstrapTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-init-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.bin = Path(self.temp.name) / "bin"
        self.bin.mkdir()
        git = self.bin / "git"
        git.write_text('''#!/usr/bin/python3
import json
import os
from pathlib import Path
import sys
args = sys.argv[1:]
with open(Path(os.environ["HOME"]) / "git-calls", "a") as log:
    log.write(json.dumps(args) + "\\n")
if args[0] == "clone":
    if os.environ.get("CLONE_FAIL"):
        sys.exit(1)
    target = Path(args[-1])
    target.mkdir(parents=True)
    (target / ".git").mkdir()
    (target / "deploy.sh").write_text(
        '#!/bin/bash\\nprintf "%s\\\\n" "$@" > "$HOME/deploy-args"\\n'
        'printf "deploy:%s\\\\n" "${1:-apply}" >> "$HOME/setup-calls"\\n'
        'cat > "$HOME/deploy-stdin"\\n'
        'exit "${DEPLOY_STATUS:-0}"\\n')
    (target / "sh").mkdir()
    (target / "sh/setup-tools.sh").write_text(
        '#!/bin/bash\\nprintf "tools\\\\n" >> "$HOME/setup-calls"\\n'
        'exit "${TOOLS_STATUS:-0}"\\n')
''')
        git.chmod(0o755)
        uname = self.bin / "uname"
        uname.write_text('#!/bin/sh\nprintf "%s\\n" "${TEST_OS:-Linux}"\n')
        uname.chmod(0o755)
        nix = self.bin / "nix"
        nix.write_text('#!/bin/sh\nexit 0\n')
        nix.chmod(0o755)
        brew = self.bin / "brew"
        brew.write_text('#!/bin/sh\nexit 0\n')
        brew.chmod(0o755)
        self.env = {"HOME": str(self.home), "PATH": f"{self.bin}:/usr/bin:/bin"}

    def run_init(self, *args, success=True, local=False):
        command = ["bash", str(ROOT / "init.sh")] if local else ["bash", "-s", "--"]
        result = subprocess.run(
            [*command, *args], input=None if local else (ROOT / "init.sh").read_text(),
            cwd=self.home, env=self.env, capture_output=True, text=True,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def test_stdin_clone_and_repeat_without_pull(self):
        self.run_init()
        self.run_init()
        calls = [json.loads(line) for line in (self.home / "git-calls").read_text().splitlines()]
        self.assertEqual(calls, [["clone", "--branch", "main", "--",
                                 "https://github.com/umasoya/dotfiles.git",
                                 str(self.home / "dotfiles")]])
        self.assertEqual((self.home / "deploy-stdin").read_text(), "")

    def test_custom_destination_ref_and_dry_run(self):
        self.env.update(DOT_DIR=str(self.home / "custom checkout"), DOTFILES_REF="feature/setup")
        self.run_init("--dry-run")
        self.assertTrue((self.home / "custom checkout/.git").is_dir())
        self.assertIn("feature/setup", (self.home / "git-calls").read_text())
        self.assertEqual((self.home / "deploy-args").read_text(), "--dry-run\n")
        self.assertEqual((self.home / "setup-calls").read_text(), "deploy:--dry-run\n")

    def test_non_checkout_is_preserved(self):
        target = self.home / "dotfiles"
        target.mkdir()
        (target / "keep").write_text("keep me")
        self.run_init(success=False)
        self.assertEqual((target / "keep").read_text(), "keep me")
        self.assertFalse((self.home / "deploy-args").exists())

    def test_clone_failure_stops(self):
        self.env["CLONE_FAIL"] = "1"
        self.run_init(success=False)
        self.assertFalse((self.home / "deploy-args").exists())

    def test_deployment_failure_is_propagated(self):
        self.env["DEPLOY_STATUS"] = "7"
        result = self.run_init(success=False)
        self.assertEqual(result.returncode, 7)
        self.assertNotIn("Next:", result.stdout)
        self.assertEqual((self.home / "setup-calls").read_text(), "deploy:--dry-run\n")

    def test_preflight_and_installation_precede_deployment(self):
        self.run_init()
        self.assertEqual((self.home / "setup-calls").read_text(),
                         "deploy:--dry-run\ntools\ndeploy:apply\n")

    def test_tool_failure_stops_before_deployment(self):
        self.env["TOOLS_STATUS"] = "8"
        self.assertEqual(self.run_init(success=False).returncode, 8)
        self.assertEqual((self.home / "setup-calls").read_text(),
                         "deploy:--dry-run\ntools\n")

    def test_missing_deploy_script_stops(self):
        (self.home / "dotfiles/.git").mkdir(parents=True)
        self.env["DOTFILES_REF"] = "feature/setup"
        result = self.run_init(success=False)
        self.assertIn("Missing deploy.sh", result.stderr)
        self.assertIn("DOTFILES_REF defaults to main", result.stderr)
        self.assertIn("not updated or switched automatically", result.stderr)
        self.assertFalse((self.home / "git-calls").exists())
        self.assertFalse((self.home / "setup-calls").exists())

    def test_invalid_arguments_do_not_clone(self):
        self.run_init("--force", success=False)
        self.run_init("--dry-run", "extra", success=False)
        self.assertEqual(list(self.home.iterdir()), [])

    def test_unsupported_os_does_not_clone(self):
        self.env["TEST_OS"] = "FreeBSD"
        self.run_init(success=False)
        self.assertEqual(list(self.home.iterdir()), [])

    def test_local_entry_point_uses_checkout(self):
        result = self.run_init("--dry-run", local=True)
        self.assertIn(str(ROOT), result.stdout)
        self.assertFalse((self.home / ".bashrc").exists())
        self.assertFalse((self.home / "git-calls").exists())

    def test_stdin_runs_real_deployment_on_supported_platforms(self):
        (self.home / "dotfiles").symlink_to(ROOT, target_is_directory=True)
        for platform in ("Linux", "Darwin"):
            with self.subTest(platform=platform):
                self.env["TEST_OS"] = platform
                self.run_init()
                self.assertEqual((self.home / ".bashrc").resolve(), ROOT / ".bashrc")
                self.assertEqual((self.home / ".codex/skills/github-pr-create").resolve(),
                                 ROOT / "agents/skills/github-pr-create")
        self.assertTrue((self.home / ".config/ghostty").is_symlink())

    def test_stdin_real_deployment_preserves_conflicting_settings(self):
        (self.home / "dotfiles").symlink_to(ROOT, target_is_directory=True)
        (self.home / ".bashrc").write_text("keep me")
        result = self.run_init(success=False)
        self.assertIn("Conflict:", result.stderr)
        self.assertEqual((self.home / ".bashrc").read_text(), "keep me")
        self.assertFalse((self.home / ".vimrc").exists())
        self.assertFalse((self.home / "git-calls").exists())


if __name__ == "__main__":
    unittest.main()
