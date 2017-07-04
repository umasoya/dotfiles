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

# If the command does not exist and matches Dir name, move to Dir
setopt auto_cd

# no beep
setopt no_beep

# Enable autocomplete
autoload -U compinit; compinit

# 大文字小文字を区別せずに補完
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 移動先ディレクトリをスタック(履歴)に追加する
setopt auto_pushd

# ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

# 拡張glob(パス名にマッチするワイルドカードパターン)の有効化
setopt extended_glob

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
setopt hist_ignore_space

# <tab>でパス名の補完候補を表示後、続けて<tab>を押すと候補からパス名を選択できるようにする
zstyle ':completion:*:default' menu select=1

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
