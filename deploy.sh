#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
dry_run=false
interactive=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        --interactive) interactive=true ;;
        *)
            echo "Usage: $0 [--dry-run] [--interactive]" >&2
            exit 2
            ;;
    esac
done

sources=()
targets=()
add_link() {
    sources+=("$DOTFILES_DIR/$1")
    targets+=("$2")
}
for name in .bash_profile .bashrc .zprofile .zshenv .zshrc; do
    add_link "$name" "$HOME/$name"
done
add_link git/.gitconfig "$HOME/.gitconfig"
add_link git/.gitignore "$HOME/.gitignore"
if [[ -f "$DOTFILES_DIR/git/.gitconfig.local" ]]; then
    add_link git/.gitconfig.local "$HOME/.gitconfig.local"
fi
add_link config/nvim "$CONFIG_HOME/nvim"
add_link config/herdr/config.toml "$CONFIG_HOME/herdr/config.toml"
add_link agents/AGENTS.md "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
add_link agents/skills/github-pr-create "${CODEX_HOME:-$HOME/.codex}/skills/github-pr-create"
add_link agents/AGENTS.md "$HOME/.claude/CLAUDE.md"
add_link agents/mcp/apm.yml "$HOME/.apm/apm.yml"
add_link agents/mcp/run.sh "$HOME/.apm/dotfiles-mcp.sh"
if [[ "$(uname -s)" == Darwin ]]; then
    add_link config/karabiner/karabiner.json "$CONFIG_HOME/karabiner/karabiner.json"
    add_link config/karabiner/assets "$CONFIG_HOME/karabiner/assets"
    add_link config/ghostty "$CONFIG_HOME/ghostty"
fi

# Ubuntu's unchanged skeleton file can be replaced on first-time setup.
is_default_bashrc() {
    [[ "$1" == "$HOME/.bashrc" && -f "$1" && ! -L "$1" && -f /etc/skel/.bashrc ]] &&
        cmp -s -- "$1" /etc/skel/.bashrc
}

# Check every destination before making any changes, including dangling symlinks.
conflicts=0
replacements=()
for i in "${!sources[@]}"; do
    source_path="${sources[$i]}"
    target="${targets[$i]}"
    parent="$(dirname -- "$target")"
    while [[ ! -d "$parent" && "$parent" != / ]]; do
        if [[ -e "$parent" || -L "$parent" ]]; then
            echo "Conflict: parent is not a directory: $parent" >&2
            conflicts=1
            break
        fi
        parent="$(dirname -- "$parent")"
    done
    if [[ ! -e "$source_path" ]]; then
        echo "Missing source: $source_path" >&2
        conflicts=1
    elif [[ "$target" -ef "$source_path" ]]; then
        continue
    elif is_default_bashrc "$target"; then
        continue
    elif [[ -e "$target" || -L "$target" ]]; then
        if "$interactive" && { exec 3<>/dev/tty; } 2>/dev/null; then
            replacements+=("$i")
            printf 'Conflict: %s (confirmation required before replacement)\n' "$target" >&2
        else
            echo "Conflict: $target (move it to a backup before deploying, or use --interactive in a terminal)" >&2
            conflicts=1
        fi
    fi
done
if ((conflicts)); then
    exit 1
fi

# Collect decisions before changing any destination. Never read the streamed script.
skipped=()
if ! "$dry_run"; then
    for i in "${replacements[@]}"; do
        printf 'Replace %s? Existing content will be backed up. [y/N] ' "${targets[$i]}" >&3
        answer=""
        if IFS= read -r answer <&3 && [[ "$answer" == y || "$answer" == Y || "$answer" == yes || "$answer" == YES ]]; then
            continue
        fi
        skipped+=("$i")
        printf 'Skip: %s\n' "${targets[$i]}"
    done
fi

backup_dir=""
for i in "${!sources[@]}"; do
    target="${targets[$i]}"
    [[ "$target" -ef "${sources[$i]}" ]] && continue
    skip=false
    for skipped_index in "${skipped[@]}"; do
        [[ "$i" == "$skipped_index" ]] && skip=true
    done
    "$skip" && continue
    if "$dry_run"; then
        if is_default_bashrc "$target"; then
            printf 'Replace default .bashrc: %s\n' "$target"
        fi
        printf 'Link: %s -> %s\n' "$target" "${sources[$i]}"
    else
        mkdir -p -- "$(dirname -- "$target")"
        for replacement_index in "${replacements[@]}"; do
            if [[ "$i" == "$replacement_index" ]]; then
                if [[ -z "$backup_dir" ]]; then
                    backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups"
                    mkdir -p -- "$backup_root"
                    backup_dir="$(mktemp -d "$backup_root/deploy.XXXXXXXX")"
                fi
                mv -- "$target" "$backup_dir/$i"
                printf 'Backup: %s -> %s/%s\n' "$target" "$backup_dir" "$i"
            fi
        done
        if is_default_bashrc "$target"; then
            ln -sf -- "${sources[$i]}" "$target"
        else
            ln -s -- "${sources[$i]}" "$target"
        fi
    fi
done
if ! "$dry_run"; then
    git -C "$DOTFILES_DIR" config core.hooksPath .githooks
fi
