## bashrc
## Yasuto Souma
##

# Set the pager to less
export PAGER=less
# Display filename,number,percentage
export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'

# Prompt custumize
PS1="\nUser:\u\n[\W] >"

# alias
alias ls='ls -CF'
alias la='ls -a'
