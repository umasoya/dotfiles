#{{{ suffix aliases
alias -s tar.gz='tar zxvf'
#}}}

if (( $+is_mac )); then
  alias ls="gls -F --color=auto"
else
  alias ls="ls --color=auto"
fi

alias la='ls -a'
alias ll='ls -l'

if (( $+commands[nvim] )); then
    alias vi='nvim'
    alias nv='nvim'
    alias nvi='nvim'
elif (( $+commands[vim] )); then
    alias vi='vim'
fi
alias vw='view'

alias reshell='exec ${SHELL} -l'
alias rc='source ${HOME}/.zshrc'

alias post='curl -sS -X POST'
alias get='curl -sS -X GET'
