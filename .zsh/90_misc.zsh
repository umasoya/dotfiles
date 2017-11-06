# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Run tmux, if it is not running.
if [[ $+commands[tmux] -eq 1 && -z $TMUX && ! -z $PS1 ]]; then
        exec tmux
fi
