#!/usr/bin/env python3
"""Register shared MCP definitions without replacing client configuration files."""

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tomllib


DIRECTORY = Path(__file__).resolve().parent


def definitions(client):
    servers = json.loads((DIRECTORY / "servers.json").read_text())
    result = {}
    for name, server in servers.items():
        if "url" in server:
            config = {"url": server["url"]}
            if client == "claude":
                config["type"] = "http"
            if token := server.get("token_env"):
                if client == "codex":
                    config["bearer_token_env_var"] = token
                else:
                    config["headers"] = {"Authorization": "Bearer ${" + token + "}"}
        else:
            config = {
                "command": server["command"],
                "args": [
                    arg.replace("{launcher}", str(DIRECTORY / "run.sh"))
                    .replace("{client}", client)
                    for arg in server["args"]
                ],
            }
            if client == "claude":
                config["type"] = "stdio"
            # Codex filters inherited stdio environment variables. Preserve a
            # custom XDG location explicitly without copying any secret values.
            if config_home := os.environ.get("XDG_CONFIG_HOME"):
                config["env"] = {"XDG_CONFIG_HOME": config_home}
        result[name] = config
    return result


def existing_servers(client):
    home = Path.home()
    if client == "codex":
        path = Path(os.environ.get("CODEX_HOME", home / ".codex")) / "config.toml"
        if not path.exists():
            return {}
        with path.open("rb") as source:
            return tomllib.load(source).get("mcp_servers", {})
    config_dir = os.environ.get("CLAUDE_CONFIG_DIR")
    path = Path(config_dir) / ".claude.json" if config_dir else home / ".claude.json"
    if not path.exists():
        return {}
    return json.loads(path.read_text()).get("mcpServers", {})


def matches(existing, desired):
    # Keep extra local settings, including disabled state, timeouts and tool limits.
    return all(existing.get(key) == value for key, value in desired.items())


def add_command(client, name, config):
    if client == "claude":
        return ["claude", "mcp", "add-json", "--scope", "user", name, json.dumps(config)]
    command = ["codex", "mcp", "add", name]
    if "url" in config:
        command += ["--url", config["url"]]
        if token := config.get("bearer_token_env_var"):
            command += ["--bearer-token-env-var", token]
    else:
        for key, value in config.get("env", {}).items():
            command += ["--env", f"{key}={value}"]
        command += ["--", config["command"], *config["args"]]
    return command


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--client", choices=("codex", "claude", "all"), default="all")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    clients = ("codex", "claude") if args.client == "all" else (args.client,)
    pending = []
    conflicts = []
    # Check all clients before the first mutation. Never print existing values.
    for client in clients:
        existing = existing_servers(client)
        for name, config in definitions(client).items():
            if name in existing:
                if not matches(existing[name], config):
                    conflicts.append(f"{client}/{name}")
                continue
            pending.append((client, name, config))
    if conflicts:
        raise ValueError("Conflicting MCP definitions (nothing changed): " + ", ".join(conflicts))
    if not args.dry_run:
        for client in clients:
            if not shutil.which(client):
                raise ValueError(f"Missing client executable: {client}")
    for client, name, config in pending:
        if args.dry_run:
            print(f"Add: {client}/{name}")
            continue
        # Official CLIs preserve unrelated settings and handle their own writes.
        completed = subprocess.run(add_command(client, name, config), capture_output=True)
        if completed.returncode:
            # Client output can contain existing secrets: report only the name.
            raise ValueError(f"Registration failed: {client}/{name}; check the client locally")
        print(f"Added: {client}/{name}")
    if not pending:
        print("Shared MCP definitions already registered.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, tomllib.TOMLDecodeError):
        # Parser errors can include portions of machine-local configuration.
        # ValueError messages above are generated without local configuration values.
        error = sys.exc_info()[1]
        if type(error) is ValueError:
            print(error, file=sys.stderr)
        else:
            print("Cannot read or update MCP configuration; check local files and permissions.", file=sys.stderr)
        sys.exit(1)
