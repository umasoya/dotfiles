# {{{1 Completions
#
# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Ignore completion matches pattern
zstyle ':completion:*:*:(vi|vim):*files' ignored-patterns '(*.swp|*.tmp|*~|.DS_Store)'
# Ignore completion if selected parent dir
zstyle ':completion:*:(cd|mv|cp|gitcd):*' ignore-parents parent pwd
# if not exists target at current candidate target at parent dir
zstyle ':completion:*:(cd|gitcd):*' tag-order local-directories path-directories
# Ignore already in the line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

zstyle ':completion:*' list-separator '==>'
# }}}

# Run tmux, if it is not running.
if [[ $+commands[tmux] -eq 1 && -z $TMUX && ! -z $PS1 ]]; then
        exec tmux
fi
