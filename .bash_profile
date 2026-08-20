# 共通環境変数の読み込み
[ -r "$HOME/dotfiles/sh/env" ] && . "$HOME/dotfiles/sh/env"
[ -r "$HOME/dotfiles/sh/brew.sh" ] && . "$HOME/dotfiles/sh/brew.sh"
# bashrcの読み込み
[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
