"""Exercise deployment without touching the user's home or repository Git config."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class DeploymentTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.bin = Path(self.temp.name) / "bin"
        self.bin.mkdir()
        for name, content in {
            "git": '#!/bin/sh\nprintf "git\\n" >> "$HOME/git-called"\n',
            "uname": '#!/bin/sh\nprintf "%s\\n" "${TEST_OS:-Linux}"\n',
        }.items():
            path = self.bin / name
            path.write_text(content)
            path.chmod(0o755)
        self.env = {"HOME": str(self.home), "PATH": f"{self.bin}:/usr/bin:/bin"}

    def run_deploy(self, *args, success=True):
        result = subprocess.run(
            ["bash", str(ROOT / "deploy.sh"), *args], env=self.env,
            text=True, capture_output=True,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def test_dry_run_has_no_side_effects(self):
        self.assertIn("Link:", self.run_deploy("--dry-run").stdout)
        self.assertEqual(list(self.home.iterdir()), [])

    def test_linux_deployment_is_idempotent(self):
        self.run_deploy()
        self.run_deploy()
        self.assertEqual((self.home / ".vimrc").resolve(), ROOT / "vim/.vimrc")
        self.assertEqual((self.home / ".claude/CLAUDE.md").resolve(), ROOT / "agents/AGENTS.md")
        self.assertFalse((self.home / ".config/karabiner").exists())
        self.assertFalse((self.home / ".tmux.conf").exists())
        self.assertEqual((self.home / ".codex/skills/github-pr-create").resolve(),
                         ROOT / "agents/skills/github-pr-create")

    def test_existing_skill_prevents_all_changes(self):
        target = self.home / ".codex/skills/github-pr-create"
        target.mkdir(parents=True)
        (target / "SKILL.md").write_text("keep me")
        self.run_deploy(success=False)
        self.assertEqual((target / "SKILL.md").read_text(), "keep me")
        self.assertFalse((self.home / ".bashrc").exists())

    def test_other_skills_are_preserved(self):
        target = self.home / ".codex/skills/other-skill"
        target.mkdir(parents=True)
        (target / "SKILL.md").write_text("keep me")
        self.run_deploy()
        self.assertEqual((target / "SKILL.md").read_text(), "keep me")

    def test_file_conflict_prevents_all_changes(self):
        target = self.home / ".vimrc"
        target.write_text("keep me")
        self.assertIn("Conflict:", self.run_deploy(success=False).stderr)
        self.assertEqual(target.read_text(), "keep me")
        self.assertFalse((self.home / ".bashrc").exists())
        self.assertFalse((self.home / "git-called").exists())

    def test_broken_symlink_is_preserved(self):
        target = self.home / ".vimrc"
        target.symlink_to("missing")
        self.run_deploy(success=False)
        self.assertEqual(os.readlink(target), "missing")
        self.assertFalse((self.home / ".bashrc").exists())

    def test_parent_file_prevents_all_changes(self):
        (self.home / ".claude").write_text("keep me")
        self.run_deploy(success=False)
        self.assertFalse((self.home / ".bashrc").exists())

    def test_macos_and_custom_roots(self):
        self.env.update(TEST_OS="Darwin", XDG_CONFIG_HOME=str(self.home / "settings"),
                        CODEX_HOME=str(self.home / "codex"))
        self.run_deploy()
        self.assertEqual((self.home / "settings/karabiner/karabiner.json").resolve(),
                         ROOT / "config/karabiner/karabiner.json")
        self.assertTrue((self.home / "settings/ghostty").is_symlink())
        self.assertTrue((self.home / "codex/AGENTS.md").is_symlink())
        self.assertEqual((self.home / "codex/skills/github-pr-create").resolve(),
                         ROOT / "agents/skills/github-pr-create")

    def test_unknown_argument(self):
        self.run_deploy("--force", success=False)
        self.assertEqual(list(self.home.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
