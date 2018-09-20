source $HOME/dotfiles/.config/sh/.env

# Load zmodule zprof
#zmodload zsh/zprof && zprof 1>/dev/null

# Do not regist duplicate path.
typeset -gx -U path cdpath fpath

#(N-/): Do not regist path if it is not exist.
for i in $paths; do
    path=($path "${i}(N-/)")
done

fpath=(
  $HOME/dotfiles/.zsh/completions(N-/)
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
