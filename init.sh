#!/usr/bin/env bash

set -euo pipefail

# Clone dotfiles repository if it doesn't exist
DOTFILES_REPO="https://github.com/umasoya/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
if [ ! -d "${DOTFILES_DIR}/.git" ]; then
    echo "Cloning dotfiles..."
    git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

# Install afx
if ! command -v afx &> /dev/null; then
    echo "Installing afx..."
    curl -sL https://raw.githubusercontent.com/babarot/afx/HEAD/hack/install | bash
    afx install
fi

# Show post-installation TODOs
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

echo
printf '%b\n' "${YELLOW}📝 TODO:${RESET}"
echo "  🔑 Change the dotfiles repository remote to SSH"
printf '     %b%s%b\n' \
    "${CYAN}" \
    "git -C \"${DOTFILES_DIR}\" remote set-url origin git@github.com:umasoya/dotfiles.git" \
    "${RESET}"
