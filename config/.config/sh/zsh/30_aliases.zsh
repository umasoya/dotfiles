#{{{ suffix aliases
alias -s tar.gz='tar zxvf'
#}}}

if (( $+commands[exa] )); then
  alias ls='exa'
else
  alias ls="ls --color=auto"
fi

alias la='ls -a'
alias ll='ls -l'

alias grep='grep --color=auto -n'

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
