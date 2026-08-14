# 対話型シェル以外なら、この先の設定は不要なので読み込みを終了する
case $- in
    *i*) ;;
      *) return;;
esac

# history に記録するルールを指定する環境変数
HISTCONTROL=ignoreboth

# 重複・スペース開始を保存しない
shopt -s histappend

# コマンド履歴の保持数
HISTSIZE=1000
HISTFILESIZE=4000

# コマンド実行ごとに即座に `.bash_history` へ書き込み
PROMPT_COMMAND='history -a'

# ターミナルのサイズ変更を検知し、自動更新
shopt -s checkwinsize

# "**"が再帰的にすべてのディレクトリを意味する
shopt -s globstar

# lessをいい感じにする設定
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# 256色対応
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# プロンプト表示
PS1='\[\e[90m\][\t]\[\e[0m\] \[\e[32m\]\u@\h\[\e[0m\] \[\e[34m\]\w\[\e[0m\]\n \$ '

# 色設定
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# タブ補完
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

