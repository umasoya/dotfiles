alias rc='source ~/.bashrc'
alias reshell='exec ${SHELL} -l'

alias ls='ls -CF'
alias ls='ls --color=auto'
alias la='ls -a'

alias vi='vim'
alias vw='view'

cdls(){
  \cd "$@" && la
}
alias cd="cdls"
