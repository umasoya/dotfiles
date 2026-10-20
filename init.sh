#!/usr/bin/env bash
# Keep the streamed script together before running commands that may read stdin.
main() {
    set -euo pipefail

    case "${1:-}" in
        "" | --dry-run) ;;
        *)
            echo "Usage: init.sh [--dry-run]" >&2
            return 2
            ;;
    esac
    if (($# > 1)); then
        echo "Usage: init.sh [--dry-run]" >&2
        return 2
    fi
    case "$(uname -s)" in
        Darwin | Linux) ;;
        *)
            echo "Unsupported operating system" >&2
            return 1
            ;;
    esac
    if ! command -v git >/dev/null 2>&1; then
        echo "Git is required. Install Git, then run this script again." >&2
        return 1
    fi

    local script_dir="" dotfiles_dir
    if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
        script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
    fi
    if [[ -n "$script_dir" && -f "$script_dir/deploy.sh" ]]; then
        dotfiles_dir="$script_dir"
    else
        dotfiles_dir="${DOT_DIR:-$HOME/dotfiles}"
        if [[ ! -e "$dotfiles_dir" && ! -L "$dotfiles_dir" ]]; then
            git clone --branch "${DOTFILES_REF:-main}" -- \
                https://github.com/umasoya/dotfiles.git "$dotfiles_dir" </dev/null
        elif [[ ! -d "$dotfiles_dir/.git" && ! -f "$dotfiles_dir/.git" ]]; then
            echo "Conflict: $dotfiles_dir is not a Git checkout" >&2
            return 1
        fi
    fi
    if [[ ! -f "$dotfiles_dir/deploy.sh" ]]; then
        echo "Missing deploy.sh in $dotfiles_dir. Update the checkout before retrying." >&2
        return 1
    fi
    # Detect configuration conflicts before downloading or installing software.
    bash "$dotfiles_dir/deploy.sh" --dry-run </dev/null
    if [[ "${1:-}" == --dry-run ]]; then
        printf '%s\n' 'Dry run: software installation and configuration deployment were skipped.'
        return
    fi
    bash "$dotfiles_dir/sh/setup-tools.sh" "$dotfiles_dir" </dev/null
    bash "$dotfiles_dir/deploy.sh" </dev/null
    printf '\n%s\n' "✅ Setup complete: $dotfiles_dir"
    printf '%s\n' '🔄 Open a new login shell to use the installed CLI tools.' \
        '' '📝 TODO: Switch this repository to SSH:'
    printf '  git -C "%s" remote set-url origin git@github.com:umasoya/dotfiles.git\n' "$dotfiles_dir"
}

main "$@"
