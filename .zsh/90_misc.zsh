# Run tmux, if it is not running.
if [[ $+commands[tmux] -eq 1 && -z $TMUX && ! -z $PS1 ]]; then
        exec tmux
fi

# Hook direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi
