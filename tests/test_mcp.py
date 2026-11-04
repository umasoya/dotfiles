"""Verify MCP registration and launchers with isolated configuration and fake tools."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib
import unittest

ROOT = Path(__file__).resolve().parents[1]
APM = os.environ.get("APM_TEST_EXECUTABLE")
NAMES = {"serena", "github", "docker", "cloudflare", "chrome-devtools"}


@unittest.skipUnless(APM, "Set APM_TEST_EXECUTABLE to run APM integration tests")
class APMIntegrationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-apm-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        state = self.home / ".apm"
        state.mkdir()
        # Use a copy: tests must never let APM mutate the shared manifest.
        shutil.copy2(ROOT / "agents/mcp/apm.yml", state / "apm.yml")
        (state / "dotfiles-mcp.sh").symlink_to(ROOT / "agents/mcp/run.sh")
        self.codex = self.home / "custom codex"
        self.claude = self.home / "custom claude"
        self.codex.mkdir()
        self.claude.mkdir()
        self.bin = self.home / "bin"
        self.bin.mkdir()
        uvx = self.bin / "uvx"
        # Exercise the real repository wrapper, with uvx download replaced by
        # the explicitly selected APM executable. No network or real home.
        uvx.write_text('#!/bin/sh\nshift 5\nexec "$APM_TEST_EXECUTABLE" "$@"\n')
        uvx.chmod(0o755)
        self.env = {
            "APM_TEST_EXECUTABLE": str(Path(APM).resolve()),
            "HOME": str(self.home), "PATH": f"{self.bin}:/usr/bin:/bin",
            "XDG_CONFIG_HOME": str(self.home / "custom config"),
            "CODEX_HOME": str(self.codex), "CLAUDE_CONFIG_DIR": str(self.claude),
            "GITHUB_MCP_TOKEN": "test-secret-never-store",
        }

    def install(self, *args, success=True):
        result = subprocess.run(["bash", str(ROOT / "agents/mcp/apm.sh"), "install", "--global", "--only", "mcp", *args],
                                cwd=self.home, env=self.env, stdin=subprocess.DEVNULL, text=True, capture_output=True)
        if success:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def configs(self):
        return (tomllib.loads((self.codex / "config.toml").read_text()),
                json.loads((self.claude / ".claude.json").read_text()))

    def test_dry_run_does_not_write_client_configuration(self):
        self.install("--dry-run")
        self.assertFalse((self.codex / "config.toml").exists())
        self.assertFalse((self.claude / ".claude.json").exists())
        self.assertFalse((self.home / ".apm/apm.lock.yaml").exists())

    def test_install_repeat_preserves_unrelated_settings_and_secret_references(self):
        (self.codex / "config.toml").write_text('model = "local-model"\n[mcp_servers.personal]\ncommand = "personal"\n')
        (self.claude / ".claude.json").write_text(json.dumps({"custom": True, "mcpServers": {"personal": {"command": "personal"}}}))
        self.install()
        first = self.configs()
        self.install()
        self.assertEqual(first, self.configs())
        codex, claude = first
        self.assertEqual(codex["model"], "local-model")
        self.assertTrue(claude["custom"])
        self.assertEqual(set(codex["mcp_servers"]), NAMES | {"personal"})
        self.assertEqual(set(claude["mcpServers"]), NAMES | {"personal"})
        self.assertEqual(codex["mcp_servers"]["github"]["bearer_token_env_var"], "GITHUB_MCP_TOKEN")
        self.assertEqual(claude["mcpServers"]["github"]["headers"]["Authorization"], "Bearer ${GITHUB_MCP_TOKEN}")
        self.assertEqual(codex["mcp_servers"]["docker"]["env"]["XDG_CONFIG_HOME"], self.env["XDG_CONFIG_HOME"])
        # Check native configs and local APM ownership/lock data for leaked values.
        for path in self.home.rglob("*"):
            if path.is_file() and not path.is_symlink():
                self.assertNotIn(b"test-secret-never-store", path.read_bytes(), str(path))

    def test_conflicting_personal_connection_is_preserved(self):
        path = self.codex / "config.toml"
        path.write_text('[mcp_servers.serena]\ncommand = "personal-command"\n')
        self.install(success=False)
        self.assertEqual(tomllib.loads(path.read_text())["mcp_servers"]["serena"]["command"], "personal-command")

    def test_registered_launcher_uses_custom_xdg_environment(self):
        self.install()
        codex, claude = self.configs()
        config = Path(self.env["XDG_CONFIG_HOME"]) / "dotfiles"
        config.mkdir(parents=True)
        (config / "mcp.env").write_text("DOCKER_HOST='unix:///tmp/local docker.sock'\n")
        tools = self.home / "launcher bin"
        tools.mkdir()
        uvx = tools / "uvx"
        uvx.write_text('#!/bin/sh\nprintf "%s\\n" "$DOCKER_HOST"\n')
        uvx.chmod(0o755)
        for server in (codex["mcp_servers"]["docker"], claude["mcpServers"]["docker"]):
            env = {"HOME": str(self.home), "PATH": f"{tools}:/usr/bin:/bin"}
            # Claude resolves ${VAR} references when launching, Codex receives literals.
            for key, value in server.get("env", {}).items():
                env[key] = self.env[key] if value == "${" + key + "}" else value
            result = subprocess.run([server["command"], *server["args"]], env=env,
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("unix:///tmp/local docker.sock", result.stdout)


class MCPLauncherTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-mcp-run-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.bin = self.home / "bin"
        self.bin.mkdir()
        for tool in ("uvx", "npx"):
            path = self.bin / tool
            path.write_text('#!/bin/sh\nprintf "%s\\n" "$@"\nprintf "URI=%s\\n" "${DATABASE_URI:-}"\nprintf "HOST=%s\\n" "${DOCKER_HOST:-}"\n')
            path.chmod(0o755)
        docker = self.bin / "docker"
        docker.write_text('#!/bin/sh\nprintf "unix:///tmp/test-docker.sock\\n"\n')
        docker.chmod(0o755)
        self.env = {"HOME": str(self.home), "PATH": f"{self.bin}:/usr/bin:/bin"}

    def launch(self, *args, env=None):
        return subprocess.run(["bash", str(ROOT / "agents/mcp/run.sh"), *args],
                              env={**self.env, **(env or {})}, text=True, capture_output=True)

    def test_postgres_is_blocked_before_dependency_download_or_connection(self):
        for env in ({}, {"DATABASE_URI": "postgresql://fake:secret@localhost/test"}):
            with self.subTest(env=env):
                result = self.launch("postgres", env=env)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertIn("CVE-2026-85620", result.stderr)
                self.assertNotIn("secret", result.stderr)

    def test_local_env_with_custom_xdg_path(self):
        config = self.home / "custom config"
        (config / "dotfiles").mkdir(parents=True)
        (config / "dotfiles/mcp.env").write_text("DOCKER_HOST='unix:///tmp/local docker.sock'\n")
        result = self.launch("docker", env={"XDG_CONFIG_HOME": str(config)})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("HOST=unix:///tmp/local docker.sock", result.stdout)

    def test_docker_respects_context_and_explicit_host(self):
        result = self.launch("docker")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("HOST=unix:///tmp/test-docker.sock", result.stdout)
        result = self.launch("docker", env={"DOCKER_HOST": "unix:///tmp/explicit.sock"})
        self.assertIn("HOST=unix:///tmp/explicit.sock", result.stdout)

    def test_chrome_connection_and_executable_paths_with_spaces(self):
        result = self.launch("chrome-devtools", env={"CHROME_MCP_EXECUTABLE": "/test path/chrome"})
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("--isolated\n--executable-path\n/test path/chrome\n", result.stdout)
        result = self.launch("chrome-devtools", env={"CHROME_MCP_BROWSER_URL": "http://localhost:9222"})
        self.assertIn("--browser-url\nhttp://localhost:9222\n", result.stdout)
        self.assertNotIn("--isolated", result.stdout)

    def test_serena_default_uses_shared_agent_context(self):
        result = self.launch("serena")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("--context\nagent\n--project-from-cwd", result.stdout)

    def test_serena_contexts_and_project_discovery(self):
        for client, context in (("codex", "codex"), ("claude", "claude-code")):
            result = self.launch("serena", client)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn(f"--context\n{context}\n--project-from-cwd", result.stdout)


if __name__ == "__main__":
    unittest.main()
