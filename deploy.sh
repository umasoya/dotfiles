#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
dry_run=false
case "${1:-}" in
    --dry-run) dry_run=true ;;
    "") ;;
    *)
        echo "Usage: $0 [--dry-run]" >&2
        exit 2
        ;;
esac
if (($# > 1)); then
    echo "Usage: $0 [--dry-run]" >&2
    exit 2
fi

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
add_link vim/.vimrc "$HOME/.vimrc"
add_link vim/.vim "$HOME/.vim"
add_link config/herdr/config.toml "$CONFIG_HOME/herdr/config.toml"
add_link agents/AGENTS.md "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
add_link agents/skills/github-pr-create "${CODEX_HOME:-$HOME/.codex}/skills/github-pr-create"
add_link agents/AGENTS.md "$HOME/.claude/CLAUDE.md"
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
    elif [[ -L "$target" && "$(readlink "$target")" == "$source_path" ]]; then
        continue
    elif is_default_bashrc "$target"; then
        continue
    elif [[ -e "$target" || -L "$target" ]]; then
        echo "Conflict: $target (move it to a backup before deploying)" >&2
        conflicts=1
    fi
done
if ((conflicts)); then
    exit 1
fi

for i in "${!sources[@]}"; do
    target="${targets[$i]}"
    [[ -L "$target" ]] && continue
    if "$dry_run"; then
        if is_default_bashrc "$target"; then
            printf 'Replace default .bashrc: %s\n' "$target"
        fi
        printf 'Link: %s -> %s\n' "$target" "${sources[$i]}"
    else
        mkdir -p -- "$(dirname -- "$target")"
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
