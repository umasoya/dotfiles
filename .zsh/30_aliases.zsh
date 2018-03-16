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
alias vi='vim'
alias nv='nvim'
alias nvi='nvim'
alias vw='view'
alias reshell='exec ${SHELL} -l'
alias rc='source ${HOME}/.zshrc'
