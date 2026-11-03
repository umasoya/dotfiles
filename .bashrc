# shellcheck disable=SC1090,SC1091
# 対話型シェル以外なら、この先の設定は不要なので読み込みを終了する
case $- in
    *i*) ;;
    *) return ;;
esac

[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/brew.sh" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/brew.sh"
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/nix.sh" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/nix.sh"
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/env" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/env"

# -----------------------------------------------------------------------------
# Init
# -----------------------------------------------------------------------------
# load dircolors
[ -r "$DOT_DIR/sh/dircolors.sh" ] && . "$DOT_DIR/sh/dircolors.sh"

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

shopt -u cdable_vars
shopt -u cdspell
shopt -s checkhash
shopt -u checkwinsize
shopt -s cmdhist
shopt -u dotglob
shopt -u execfail
shopt -s expand_aliases
shopt -u extdebug
shopt -s extglob
shopt -s extquote
shopt -u failglob
shopt -s force_fignore

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

# macOS標準のBash 3.2でもエラーなく起動する。
if ((BASH_VERSINFO[0] >= 4)); then
    shopt -s autocd checkjobs dirspell globstar
fi

# lessをいい感じにする設定
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# プロンプト表示
PS1='\[\e[90m\][\t]\[\e[0m\] \[\e[32m\]\u@\h\[\e[0m\] \[\e[34m\]\w\[\e[0m\]\n \$ '

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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Machine-specific interactive settings.
if [ -r "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
