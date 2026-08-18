#!/usr/bin/env bash

set -euo pipefail

DOTFILES_REPO="https://github.com/umasoya/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
XDG_CONFIG_HOME="${HOME}/.config"

# Clone dotfiles repository if it doesn't exist
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

# Deploy dotfiles using GNU Stow
deploy_symlinks(){
    # 配置先ディレクトリ:ターゲットで擬似的なタプルのように定義
    local items=(
        "$HOME:.bashrc"
        "$HOME:git"
        "$XDG_CONFIG_HOME:afx"
    )
    for item in "${items[@]}"; do
        IFS=':' read -r target item <<< "$item"
        if [ ! -d "$target" ]; then
            mkdir -p "$target"
        fi
        stow --dir="${DOTFILES_DIR}" -t "$target" -vR "$item"
    done
}
deploy_symlinks

# Show post-installation TODOs
print_todo(){
    local YELLOW='\033[33m'
    local CYAN='\033[36m'
    local RESET='\033[0m'

    echo
    printf '%b\n' "${YELLOW}📝 TODO:${RESET}"
    echo "  🔑 Change the dotfiles repository remote to SSH"
    printf '     %b%s%b\n' \
        "${CYAN}" \
        "git -C \"${DOTFILES_DIR}\" remote set-url origin git@github.com:umasoya/dotfiles.git" \
        "${RESET}"
}
print_todo
