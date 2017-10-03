# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Run tmux, if it is not running.
[[ -z $TMUX && ! -z $PS1 ]] > /dev/null 2>&1 && exec tmux
