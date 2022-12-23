source $HOME/dotfiles/config/.config/sh/.env

# Setup fzf
# ---------
if [[ -d $GOPATH/src/github.com/junegunn/fzf ]]; then
  export FZF="$GOPATH/src/github.com/junegunn/fzf"
  export PATH="$FZF/bin:$PATH"
  [[ $- == *i* ]] && source "$FZF/shell/completion.zsh" 2> /dev/null
  source "$FZF/shell/key-bindings.zsh"
fi

# Load zmodule zprof
#zmodload zsh/zprof && zprof 1>/dev/null

# Do not regist duplicate path.
typeset -gx -U path cdpath fpath

#(N-/): Do not regist path if it is not exist.
path=(
  $paths
  $path
)


fpath=(
  /usr/share/zsh/git-completions(N-/)
  /usr/local/share/zsh/site-functions(N-/)
  $fpath
)

cdpath=(
  $HOME
  $HOME/dotfiles/
  $cdpath
)

# autoload
autoload -Uz add-zsh-hook
autoload -Uz terminfo
autoload -Uz vcs_info
autoload -Uz compinit; compinit -C
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

# Apply the suggest even .dircolor
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
