## bashrc
## Yasuto Souma
##

# {{{1 General Settings
# Set the pager to less
export PAGER=less
# Display@pager filename,number,percentage
export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'
# Set default Editor
export EDITOR=vim
# }}}

# Prompt custumize
PS1="\n\[\e[0;36m\]\h@\u\n[\w]\[\e[00m\] \$ "

# {{{1 alias
alias ls='ls -CF'
alias la='ls -a'

cdls(){
	\cd "$@" && la
}
alias cd="cdls"

# }}}
