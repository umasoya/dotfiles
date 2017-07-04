alias ls='ls -CF'
alias ls='ls --color=auto'
alias la='ls -a'

cdls(){
  \cd "$@" && la
}
alias cd="cdls"
