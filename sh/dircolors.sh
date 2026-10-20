if command -v dircolors >/dev/null 2>&1; then
    if [ -r "${DOT_DIR:-$HOME/dotfiles}/sh/.dircolors" ]; then
        eval "$(dircolors -b "${DOT_DIR:-$HOME/dotfiles}/sh/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi
fi
