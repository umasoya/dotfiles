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

# zsh-highlighting
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern cursor)
## brackets level
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
## cursor position's brackets
# ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'

## fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  export FZF_COMPLETION_TRIGGER=''
  bindkey '^T' fzf-completion
  bindkey '^I' $fzf_default_completion
fi
