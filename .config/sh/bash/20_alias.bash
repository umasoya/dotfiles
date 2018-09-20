alias rc='source ~/.bashrc'
alias reshell='exec ${SHELL} -l'

alias ls='ls -CF'
alias ls='ls --color=auto'
alias la='ls -a'

if type nvim > /dev/null 2>&1; then
  alias vi=nvim
elif type vim > /dev/null 2>&1; then
  alias vi=vim
fi

alias vw=view

cdls(){
  \cd "$@" && la
}
alias cd="cdls"
