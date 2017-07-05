# character-set  UTF-8
export LANG=ja_JP.UTF-8

autoload -Uz add-zsh-hook
autoload -Uz terminfo

# Enable autocomplete
autoload -U compinit; compinit
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# {{{ ls coloring
autoload -U colors && colors

export LSCOLORS=gxfxcxdxbxegedabagacad
if [ -f ~/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors ~/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors ~/.dircolors)
    fi
fi

# Apply the suggest even .dircolor
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
# }}}
