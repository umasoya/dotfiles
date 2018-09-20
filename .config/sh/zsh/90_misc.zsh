# Run tmux, if it is not running.
#if [[ $+commands[tmux] -eq 1 && -z $TMUX && ! -z $PS1 ]]; then
#    if [[ ${DIST}="Chrome" ]]; then
#        exec tmux -2
#    else
#        exec tmux
#    fi
#fi

# Hook direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi
