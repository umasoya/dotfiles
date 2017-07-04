alias ls='ls -CF'
alias ls='ls --color=auto'
alias la='ls -a'

alias vi='vim'

mkgo(){
  mkdir $1 && cd $_
}

cdls(){
  \cd "$@" && la
}
alias cd="cdls"
