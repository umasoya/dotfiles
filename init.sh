#!/usr/bin/env bash

set -euo pipefail

DOTFILES_REPO="https://github.com/umasoya/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
XDG_CONFIG_HOME="${HOME}/.config"

# Detect operating system and print "mac" or "linux"
detect_os() {
    local kernel_name
    kernel_name="$(uname -s)"

    case "${kernel_name}" in
        Darwin)
            printf 'mac\n'
            ;;
        Linux)
            printf 'linux\n'
            ;;
        *)
            echo "Unsupported OS: ${kernel_name}" >&2
            return 1
            ;;
    esac
}
OS="$(detect_os)"

# Install Homebrew if not already installed (for macOS)
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
}
if [ "${OS}" = "mac" ]; then
    install_homebrew
fi

# Clone dotfiles repository if it doesn't exist
if [ ! -d "${DOTFILES_DIR}/.git" ]; then
    echo "Cloning dotfiles..."
    git clone "${DOTFILES_REPO}" "${DOTFILES_DIR}"
fi

# Install afx
if [ ! -f "${HOME}/bin/afx" ]; then
    echo "Installing afx..."
    curl -sL https://raw.githubusercontent.com/babarot/afx/HEAD/hack/install | bash
fi

# Deploy dotfiles using symlinks
deploy_symlinks(){
    # 配置先ディレクトリ:ターゲットで擬似的なタプルのように定義
    local items=(
        "$HOME:$HOME/dotfiles/.bash_profile"
        "$HOME:$HOME/dotfiles/.bashrc"
        "$HOME:$HOME/dotfiles/.zprofile"
        "$HOME:$HOME/dotfiles/.zshenv"
        "$HOME:$HOME/dotfiles/.zshrc"
        "$HOME:$HOME/dotfiles/git/.gitconfig"
        "$HOME:$HOME/dotfiles/git/.gitignore"

        "$XDG_CONFIG_HOME:$HOME/dotfiles/afx"
        "$XDG_CONFIG_HOME:$HOME/dotfiles/config/iterm2"
        "$XDG_CONFIG_HOME:$HOME/dotfiles/config/karabiner"
    )
    for item in "${items[@]}"; do
        IFS=':' read -r target item <<< "$item"
        if [ ! -d "$target" ]; then
            mkdir -p "$target"
        fi
        ln -sf "$item" "$target"
    done
}
deploy_symlinks

# Show post-installation TODOs
print_todo(){
    local YELLOW='\033[33m'
    local CYAN='\033[36m'
    local RESET='\033[0m'

    msg=
    msg+="${YELLOW}📝 TODO:${RESET}\n"
    msg+="✔ Change the dotfiles repository remote to SSH. ${CYAN}\`git -C \"${DOTFILES_DIR}\" remote set-url origin git@github.com:umasoya/dotfiles.git\`${RESET} \n"
    msg+="✔ Install plugins using afx. ${CYAN}\`${HOME}/bin/afx install\`${RESET} \n"
    echo -e "${msg}"
}
print_todo
