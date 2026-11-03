#!/usr/bin/env bash
# shellcheck disable=SC1091
set -euo pipefail

dotfiles_dir="${1:?Usage: setup-tools.sh <checkout>}"
platform="$(uname -s)"
case "$platform" in
    Darwin | Linux) ;;
    *) exit 1 ;;
esac

# Installer prompts must use the terminal, not the streamed bootstrap script.
run_installer() (
    local installer_url="$1"
    shift
    if ! { exec 3</dev/tty; } 2>/dev/null; then
        echo 'A terminal is required to install Nix or Homebrew. Run setup from a terminal.' >&2
        exit 1
    fi
    local installer_dir
    installer_dir="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-installer.XXXXXX")"
    trap 'rm -rf -- "$installer_dir"' EXIT
    curl -fsSL "$installer_url" -o "$installer_dir/install.sh"
    bash "$installer_dir/install.sh" "$@" <&3
)

load_nix() {
    if ! command -v nix >/dev/null 2>&1; then
        # Upstream initialization scripts may read unset environment variables.
        set +u
        # shellcheck source=sh/nix.sh
        . "$dotfiles_dir/sh/nix.sh"
        set -u
    fi
    if ! command -v nix >/dev/null 2>&1; then
        local candidate
        for candidate in "$HOME/.nix-profile/bin/nix" /nix/var/nix/profiles/default/bin/nix; do
            if [[ -x "$candidate" ]]; then
                PATH="$(dirname -- "$candidate"):$PATH"
                export PATH
                break
            fi
        done
    fi
}

load_nix
if ! command -v nix >/dev/null 2>&1; then
    run_installer https://nixos.org/nix/install --daemon
    load_nix
fi
if ! command -v nix >/dev/null 2>&1; then
    echo 'Nix was not found after installation. Open a new shell and rerun setup.' >&2
    exit 1
fi
nix --version

# Keep this profile separate from personal packages. Updating it is explicit.
profile="${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles"
if [[ -e "$profile" || -L "$profile" ]]; then
    nix --extra-experimental-features 'nix-command flakes' profile list --profile "$profile"
    printf '%s\n' "Reusing Nix profile: $profile (see README.md for updates)"
else
    mkdir -p -- "$(dirname -- "$profile")"
    nix --extra-experimental-features 'nix-command flakes' profile install \
        --profile "$profile" --no-update-lock-file "$dotfiles_dir#default"
fi

if [[ "$platform" == Darwin ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        # shellcheck source=sh/brew.sh
        . "$dotfiles_dir/sh/brew.sh"
    fi
    if ! command -v brew >/dev/null 2>&1; then
        run_installer https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
        # shellcheck source=sh/brew.sh
        . "$dotfiles_dir/sh/brew.sh"
    fi
    if ! command -v brew >/dev/null 2>&1; then
        echo 'Homebrew was not found after installation. Open a new shell and rerun setup.' >&2
        exit 1
    fi
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file="$dotfiles_dir/brew/Brewfile" --no-upgrade
fi
