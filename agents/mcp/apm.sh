#!/usr/bin/env bash
set -euo pipefail

# APM 0.35 resolves Claude HTTP headers at install time. Keep these as
# runtime references; never copy the agent's credentials into native configs.
unset GITHUB_MCP_TOKEN
exec uvx --python python3.13 --from apm-cli==0.35.0 apm "$@"
