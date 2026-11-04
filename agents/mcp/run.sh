#!/usr/bin/env bash
set -euo pipefail

server="${1:-}"
client="${2:-}"
local_env="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/mcp.env"
if [[ -f "$local_env" ]]; then
    set -a
    # This is a trusted, machine-local shell file, never a project .env.
    # shellcheck disable=SC1090
    source "$local_env"
    set +a
fi

case "$server" in
    serena)
        case "$client" in
            codex) context=codex ;;
            claude) context=claude-code ;;
            *)
                echo 'Usage: run.sh serena {codex|claude}' >&2
                exit 2
                ;;
        esac
        exec uvx --python python3.13 \
            --from git+https://github.com/oraios/serena@ede329aaf0c824bea75455a2926f01420d7aa620 \
            serena start-mcp-server --context "$context" --project-from-cwd
        ;;
    docker)
        # The Python Docker SDK does not read the CLI's selected context.
        if [[ -z "${DOCKER_HOST:-}" ]]; then
            DOCKER_HOST="$(docker context inspect --format '{{.Endpoints.docker.Host}}')"
            export DOCKER_HOST
        fi
        exec uvx --python python3.13 mcp-server-docker==0.3.0
        ;;
    postgres)
        echo 'Postgres MCP is disabled pending a verified fix for CVE-2026-85620.' >&2
        exit 1
        ;;
    chrome-devtools)
        args=()
        if [[ -n "${CHROME_MCP_BROWSER_URL:-}" ]]; then
            args+=(--browser-url "$CHROME_MCP_BROWSER_URL")
        else
            args+=(--isolated)
            if [[ -n "${CHROME_MCP_EXECUTABLE:-}" ]]; then
                args+=(--executable-path "$CHROME_MCP_EXECUTABLE")
            fi
        fi
        exec npx -y chrome-devtools-mcp@1.12.0 "${args[@]}"
        ;;
    *)
        echo 'Usage: run.sh {serena {codex|claude}|docker|postgres|chrome-devtools}' >&2
        exit 2
        ;;
esac
