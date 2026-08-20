# 対話型シェル以外なら、この先の設定は不要なので読み込みを終了する
case $- in
    *i*) ;;
      *) return;;
esac
# -----------------------------------------------------------------------------
# prompt
# -----------------------------------------------------------------------------
PS1="\n\[\e[0;36m\]\h@\u [\w]\n>>>\[\e[00m\] "

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
# TAB completion
bind TAB:menu-complete

# -----------------------------------------------------------------------------
# Optrions
# -----------------------------------------------------------------------------
# -s: enable
# -u: disable

shopt -s autocd
shopt -u cdable_vars
shopt -u cdspell
shopt -s checkhash
shopt -s checkjobs
shopt -u checkwinsize
shopt -s cmdhist
shopt -u compat31
shopt -u compat32
shopt -u compat40
shopt -u compat41
shopt -s dirspell
shopt -u dotglob
shopt -u execfail
shopt -s expand_aliases
shopt -u extdebug
shopt -s extglob
shopt -s extquote
shopt -u failglob
shopt -s force_fignore
shopt -u globstar

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

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias reshell='exec ${SHELL} -l'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
# タブ補完
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------
# Hook direnv
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi

## fzf
if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
  export FZF_COMPLETION_TRIGGER=''
fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
