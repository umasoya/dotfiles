## bashrc
## Yasuto Souma
##

# Set the pager to less
export PAGER=less
# Display filename,number,percentage
export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'

# Set default Editor
export EDITOR=vim

# Prompt custumize
PS1="\n\h@\u\n[\w] >"

# alias
alias ls='ls -CF'
alias la='ls -a'
