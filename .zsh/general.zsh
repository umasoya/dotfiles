# character-set  UTF-8
export LANG=ja_JP.UTF-8

# auto reload prompt
autoload -U promptinit
promptinit
autoload -U colors && colors

autoload -Uz dd-zsh-hook
autoload -Uz terminfo

#  Vim mode setting
bindkey -v

# Enable autocomplete
autoload -U compinit; compinit

# <tab>でパス名の補完候補を表示後、続けて<tab>を押すと候補からパス名を選択できるようにする
zstyle ':completion:*:default' menu select=1

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# {{{ ls coloring
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
