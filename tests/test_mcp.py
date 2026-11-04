"""Verify MCP registration and launchers with isolated configuration and fake tools."""

import contextlib
import importlib.util
import io
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("mcp_setup", ROOT / "agents/mcp/setup.py")
SETUP = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(SETUP)


class MCPSetupTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-mcp-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.env = {"HOME": str(self.home), "PATH": "/usr/bin:/bin"}

    def main(self, *args, existing=None):
        output = io.StringIO()
        with patch.dict(os.environ, self.env, clear=True), \
                patch("sys.argv", ["setup.py", *args]), \
                patch.object(SETUP, "existing_servers", side_effect=lambda client: (existing or {}).get(client, {})), \
                patch.object(SETUP.shutil, "which", return_value="/fake/client"), \
                patch.object(SETUP.subprocess, "run", return_value=subprocess.CompletedProcess([], 0)) as run, \
                contextlib.redirect_stdout(output):
            SETUP.main()
        return run, output.getvalue()

    def test_dry_run_never_invokes_clients(self):
        run, output = self.main("--dry-run")
        run.assert_not_called()
        self.assertEqual(output.count("Add:"), 12)
        self.assertFalse((self.home / ".codex").exists())

    def test_conflict_in_second_client_prevents_all_registration(self):
        existing = {"claude": {"docker": {"command": "private-local-command"}}}
        with patch("sys.argv", ["setup.py"]), \
                patch.object(SETUP, "existing_servers", side_effect=lambda client: existing.get(client, {})), \
                patch.object(SETUP.subprocess, "run") as run:
            with self.assertRaisesRegex(ValueError, "claude/docker"):
                SETUP.main()
            run.assert_not_called()

    def test_existing_definitions_and_extra_local_settings_are_preserved(self):
        existing = {client: SETUP.definitions(client) for client in ("codex", "claude")}
        existing["codex"]["docker"]["enabled"] = False
        existing["codex"]["github"]["enabled_tools"] = ["get_me"]
        run, output = self.main(existing=existing)
        run.assert_not_called()
        self.assertIn("already registered", output)

    def test_client_selection_and_token_references(self):
        run, _ = self.main("--client", "claude")
        self.assertEqual(run.call_count, 6)
        for call in run.call_args_list:
            argv = call.args[0]
            self.assertEqual(argv[:5], ["claude", "mcp", "add-json", "--scope", "user"])
        github = SETUP.definitions("claude")["github"]
        self.assertEqual(github["headers"]["Authorization"], "Bearer ${GITHUB_MCP_TOKEN}")
        argv = SETUP.add_command("codex", "github", SETUP.definitions("codex")["github"])
        self.assertEqual(argv[-2:], ["--bearer-token-env-var", "GITHUB_MCP_TOKEN"])

    def test_custom_configuration_homes(self):
        codex = self.home / "custom codex"
        claude = self.home / "custom claude"
        codex.mkdir()
        claude.mkdir()
        (codex / "config.toml").write_text('[mcp_servers.custom]\ncommand = "custom"\n')
        (claude / ".claude.json").write_text(json.dumps({"mcpServers": {"custom": {"command": "custom"}}}))
        with patch.dict(os.environ, {**self.env, "CODEX_HOME": str(codex), "CLAUDE_CONFIG_DIR": str(claude)}, clear=True):
            for client in ("codex", "claude"):
                self.assertEqual(SETUP.existing_servers(client)["custom"]["command"], "custom")

    def test_custom_xdg_path_is_passed_without_copying_secrets(self):
        with patch.dict(os.environ, {**self.env, "XDG_CONFIG_HOME": "/custom config", "DATABASE_URI": "private-value"}, clear=True):
            config = SETUP.definitions("codex")["docker"]
            self.assertEqual(config["env"], {"XDG_CONFIG_HOME": "/custom config"})
            argv = SETUP.add_command("codex", "docker", config)
            self.assertIn("XDG_CONFIG_HOME=/custom config", argv)
            self.assertNotIn("private-value", " ".join(argv))


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

    def test_postgres_is_not_registered(self):
        for client in ("codex", "claude"):
            self.assertNotIn("postgres", SETUP.definitions(client))

    def test_postgres_is_blocked_before_dependency_download_or_connection(self):
        for env in ({}, {"DATABASE_URI": "postgresql://fake:secret@localhost/test",
                             "XDG_CONFIG_HOME": str(self.home / "custom config")}):
            with self.subTest(env=env):
                result = self.launch("postgres", env=env)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
                self.assertIn("CVE-2026-85620", result.stderr)
                self.assertNotIn("secret", result.stderr)
                self.assertNotIn("~/.config", result.stderr)

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

    def test_serena_contexts_and_project_discovery(self):
        for client, context in (("codex", "codex"), ("claude", "claude-code")):
            result = self.launch("serena", client)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn(f"--context\n{context}\n--project-from-cwd", result.stdout)


if __name__ == "__main__":
    unittest.main()
