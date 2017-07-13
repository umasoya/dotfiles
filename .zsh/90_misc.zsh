# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Run tmux, if it is not running.
if [ -z $TMUX ];then
  tmux
fi
