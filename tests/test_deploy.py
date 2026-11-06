"""Exercise deployment without touching the user's home or repository Git config."""
import os
from pathlib import Path
import shutil
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

    def run_deploy(self, *args, success=True, checkout=ROOT):
        result = subprocess.run(
            ["bash", str(checkout / "deploy.sh"), *args], env=self.env,
            text=True, capture_output=True,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def make_checkout(self):
        checkout = Path(self.temp.name) / "custom checkout"
        checkout.mkdir()
        for name in ("deploy.sh", ".bash_profile", ".bashrc", ".zprofile", ".zshenv", ".zshrc"):
            shutil.copy2(ROOT / name, checkout / name)
        for name in ("agents",):
            (checkout / name).symlink_to(ROOT / name, target_is_directory=True)
        (checkout / "git").mkdir()
        for name in (".gitconfig", ".gitignore"):
            shutil.copy2(ROOT / "git" / name, checkout / "git" / name)
        for name in ("herdr", "ghostty", "karabiner", "nvim"):
            shutil.copytree(ROOT / "config" / name, checkout / "config" / name,
                            ignore=shutil.ignore_patterns("automatic_backups", "local.config"))
        return checkout

    def test_apm_links_follow_selected_checkout(self):
        checkout = self.make_checkout()
        self.run_deploy("--dry-run", checkout=checkout)
        self.assertFalse((self.home / ".apm").exists())
        self.run_deploy(checkout=checkout)
        self.run_deploy(checkout=checkout)
        self.assertEqual((self.home / ".apm/apm.yml").resolve(), (checkout / "agents/mcp/apm.yml").resolve())
        self.assertEqual((self.home / ".apm/dotfiles-mcp.sh").resolve(), (checkout / "agents/mcp/run.sh").resolve())
        self.assertFalse((self.home / ".apm/apm.lock.yaml").exists())

    def test_existing_apm_manifest_prevents_all_changes(self):
        target = self.home / ".apm/apm.yml"
        target.parent.mkdir()
        target.write_text("name: personal\n")
        self.run_deploy(success=False)
        self.assertEqual(target.read_text(), "name: personal\n")
        self.assertFalse((self.home / ".bashrc").exists())
        self.assertFalse((self.home / ".apm/dotfiles-mcp.sh").exists())

    def test_legacy_karabiner_parent_link_is_preserved(self):
        checkout = self.make_checkout()
        self.env["TEST_OS"] = "Darwin"
        parent = self.home / ".config/karabiner"
        parent.parent.mkdir()
        relative = os.path.relpath(checkout / "config/karabiner", parent.parent)
        parent.symlink_to(relative, target_is_directory=True)
        config = checkout / "config/karabiner/karabiner.json"
        original = config.read_bytes()
        assets = sorted((checkout / "config/karabiner/assets").rglob("*"))
        self.run_deploy("--dry-run", checkout=checkout)
        self.assertFalse((self.home / ".bashrc").exists())
        self.run_deploy(checkout=checkout)
        self.run_deploy(checkout=checkout)
        self.assertEqual(os.readlink(parent), relative)
        self.assertFalse((parent / "karabiner.json").is_symlink())
        self.assertEqual(config.read_bytes(), original)
        self.assertEqual(sorted((checkout / "config/karabiner/assets").rglob("*")), assets)

    def test_custom_checkout_loads_its_local_git_config(self):
        checkout = self.make_checkout()
        local = checkout / "git/.gitconfig.local"
        local.write_text('[review]\ncheckout = selected\n')
        stale = self.home / "dotfiles/git/.gitconfig.local"
        stale.parent.mkdir(parents=True)
        stale.write_text('[review]\ncheckout = stale\n')
        self.env["DOT_DIR"] = str(checkout)
        self.run_deploy("--dry-run", checkout=checkout)
        self.assertFalse((self.home / ".gitconfig.local").exists())
        self.run_deploy(checkout=checkout)
        self.run_deploy(checkout=checkout)
        result = subprocess.run(
            ["/usr/bin/git", "config", "--global", "--includes", "--get", "review.checkout"],
            cwd=self.home, env={**self.env, "GIT_CONFIG_NOSYSTEM": "1"},
            text=True, capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.strip(), "selected")
        self.assertEqual((self.home / ".gitconfig.local").resolve(), local)

    def test_local_git_config_can_be_added_after_initial_deployment(self):
        checkout = self.make_checkout()
        self.run_deploy(checkout=checkout)
        self.assertFalse((self.home / ".gitconfig.local").is_symlink())
        local = checkout / "git/.gitconfig.local"
        local.write_text('[review]\ncheckout = selected\n')
        self.run_deploy(checkout=checkout)
        self.assertEqual((self.home / ".gitconfig.local").resolve(), local)

    def test_existing_home_local_git_config_is_preserved(self):
        checkout = self.make_checkout()
        (checkout / "git/.gitconfig.local").write_text('[review]\ncheckout = selected\n')
        target = self.home / ".gitconfig.local"
        target.write_text('[review]\ncheckout = keep\n')
        self.run_deploy(success=False, checkout=checkout)
        self.assertEqual(target.read_text(), '[review]\ncheckout = keep\n')
        self.assertFalse((self.home / ".bashrc").exists())

    def test_dry_run_has_no_side_effects(self):
        self.assertIn("Link:", self.run_deploy("--dry-run").stdout)
        self.assertEqual(list(self.home.iterdir()), [])

    def test_linux_deployment_is_idempotent(self):
        self.run_deploy()
        self.run_deploy()
        self.assertFalse((self.home / ".vimrc").exists())
        self.assertFalse((self.home / ".vimrc").is_symlink())
        self.assertEqual((self.home / ".config/nvim").resolve(), ROOT / "config/nvim")
        self.assertEqual((self.home / ".claude/CLAUDE.md").resolve(), ROOT / "agents/AGENTS.md")
        self.assertFalse((self.home / ".config/karabiner").exists())
        self.assertFalse((self.home / ".tmux.conf").exists())
        self.assertFalse((self.home / ".vim").is_symlink())
        self.assertFalse((self.home / ".vim").exists())
        self.assertEqual((self.home / ".codex/skills/github-pr-create").resolve(),
                         ROOT / "agents/skills/github-pr-create")

    def test_existing_neovim_config_prevents_all_changes(self):
        target = self.home / ".config/nvim"
        target.mkdir(parents=True)
        (target / "init.lua").write_text("-- keep me\n")
        self.run_deploy(success=False)
        self.assertEqual((target / "init.lua").read_text(), "-- keep me\n")
        self.assertFalse((self.home / ".bashrc").exists())

    def test_existing_skill_prevents_all_changes(self):
        target = self.home / ".codex/skills/github-pr-create"
        target.mkdir(parents=True)
        (target / "SKILL.md").write_text("keep me")
        self.run_deploy(success=False)
        self.assertEqual((target / "SKILL.md").read_text(), "keep me")
        self.assertFalse((self.home / ".bashrc").exists())

    def test_equivalent_relative_links_are_preserved(self):
        for platform in ("Linux", "Darwin"):
            with self.subTest(platform=platform):
                self.env["TEST_OS"] = platform
                for name, source in ((".gitignore", "git/.gitignore"),):
                    target = self.home / name
                    if target.is_symlink():
                        target.unlink()
                    relative = os.path.relpath(ROOT / source, self.home)
                    target.symlink_to(relative)
                self.run_deploy("--dry-run")
                self.run_deploy()
                for name, source in ((".gitignore", "git/.gitignore"),):
                    target = self.home / name
                    self.assertEqual(os.readlink(target), os.path.relpath(ROOT / source, self.home))

    def test_symlink_to_different_file_is_preserved(self):
        other = self.home / "other-gitignore"
        other.write_text("keep me")
        target = self.home / ".gitignore"
        target.symlink_to(other.name)
        self.run_deploy(success=False)
        self.assertEqual(os.readlink(target), other.name)
        self.assertEqual(other.read_text(), "keep me")
        self.assertFalse((self.home / ".bashrc").exists())

    def test_other_skills_are_preserved(self):
        target = self.home / ".codex/skills/other-skill"
        target.mkdir(parents=True)
        (target / "SKILL.md").write_text("keep me")
        self.run_deploy()
        self.assertEqual((target / "SKILL.md").read_text(), "keep me")

    def test_file_conflict_prevents_all_changes(self):
        target = self.home / ".gitignore"
        target.write_text("keep me")
        self.assertIn("Conflict:", self.run_deploy(success=False).stderr)
        self.assertEqual(target.read_text(), "keep me")
        self.assertFalse((self.home / ".bashrc").exists())
        self.assertFalse((self.home / "git-called").exists())

    def default_bashrc(self):
        skeleton = Path("/etc/skel/.bashrc")
        if not skeleton.is_file():
            self.skipTest("No system default .bashrc on this platform")
        target = self.home / ".bashrc"
        target.write_bytes(skeleton.read_bytes())
        return target

    def test_default_bashrc_is_replaced(self):
        target = self.default_bashrc()
        self.run_deploy()
        self.assertTrue(target.is_symlink())
        self.assertEqual(target.resolve(), ROOT / ".bashrc")
        self.run_deploy()

    def test_default_bashrc_dry_run_preserves_file(self):
        target = self.default_bashrc()
        original = target.read_bytes()
        self.assertIn("Replace default .bashrc:", self.run_deploy("--dry-run").stdout)
        self.assertFalse(target.is_symlink())
        self.assertEqual(target.read_bytes(), original)

    def test_other_conflict_preserves_default_bashrc(self):
        target = self.default_bashrc()
        original = target.read_bytes()
        (self.home / ".gitignore").write_text("keep me")
        self.run_deploy(success=False)
        self.assertFalse(target.is_symlink())
        self.assertEqual(target.read_bytes(), original)

    def test_custom_bashrc_is_preserved(self):
        target = self.default_bashrc()
        target.write_text(target.read_text() + "\n# custom settings\n")
        self.run_deploy(success=False)
        self.assertFalse(target.is_symlink())
        self.assertIn("# custom settings", target.read_text())

    def test_broken_symlink_is_preserved(self):
        target = self.home / ".gitignore"
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
        self.assertEqual((self.home / "settings/nvim").resolve(), ROOT / "config/nvim")
        self.assertTrue((self.home / "codex/AGENTS.md").is_symlink())
        self.assertEqual((self.home / "codex/skills/github-pr-create").resolve(),
                         ROOT / "agents/skills/github-pr-create")

    def test_unknown_argument(self):
        self.run_deploy("--force", success=False)
        self.assertEqual(list(self.home.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
