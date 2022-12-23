source $HOME/.config/sh/.env

# Setup fzf
# ---------
if [[ -d $GOPATH/src/github.com/junegunn/fzf ]]; then
  export FZF="$GOPATH/src/github.com/junegunn/fzf"
  export PATH="$FZF/bin:$PATH"
  [[ $- == *i* ]] && source "$FZF/shell/completion.bash" 2> /dev/null
  source "$FZF/shell/key-bindings.bash"
fi

if [[ -f ~/.bashrc ]]; then
  source ~/.bashrc
fi
