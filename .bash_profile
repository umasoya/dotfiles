# shellcheck disable=SC1090,SC1091
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/brew.sh" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/brew.sh"
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/nix.sh" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/nix.sh"
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/env" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/env"
[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
