#!/usr/bin/env bash
set -euo pipefail

case "$(uname -s)" in
    Darwin | Linux) ;;
    *)
        echo "Unsupported operating system" >&2
        exit 1
        ;;
esac

# Can be run from a checkout or piped to bash for first-time setup.
script_dir=""
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
fi
if [[ -n "$script_dir" && -f "$script_dir/deploy.sh" ]]; then
    dotfiles_dir="$script_dir"
else
    dotfiles_dir="$HOME/dotfiles"
    if [[ ! -d "$dotfiles_dir/.git" ]]; then
        git clone https://github.com/umasoya/dotfiles.git "$dotfiles_dir"
    fi
fi
bash "$dotfiles_dir/deploy.sh" "$@"
printf '%s\n' 'Next: follow README.md to install CLI tools with Nix and Mac apps with Homebrew.'
