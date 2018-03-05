# Load zmodule zprof
#zmodload zsh/zprof && zprof 1>/dev/null

# Do not regist duplicate path.
typeset -gx -U path

#(N-/): Do not regist path if it is not exist.
path=(
  /usr/local/bin(N-/)
  /usr/bin(N-/)
  /usr/local/sbin(N-/)
  $HOME/local/bin(N-/)
  $HOME/dotfiles/bin(N-/)
  /usr/local/lib/zsh/5.3.1/zsh(N-/)
  /home/vagrant/.gem/ruby/gems/bundler-1.16.1/bin(N-/)
  $path
)

# fpath
typeset -gx -U fpath

fpath=(
  $HOME/dotfiles/.zsh/completions(N-/)
  $fpath
)

cdpath=(
  $HOME
  $HOME/dotfiles/
)

# autoload
autoload -Uz add-zsh-hook
autoload -Uz terminfo
autoload -Uz vcs_info
autoload -Uz compinit; compinit -C
autoload -Uz colors && colors
autoload -Uz promptinit && promptinit

# character-set  UTF-8
export LANG=ja_JP.UTF-8
export LANGUAGE=ja

# Editor
export EDITOR=vim
export GIT_EDITOR=${EDITOR}

# Pager
export PAGER=less

# {{{ ls coloring
export LSCOLORS=GxFxCxDxBxegedabagacad
if [ -f ~/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors ~/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors ~/.dircolors)
    fi
fi

# Apply the suggest even .dircolor
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
# }}}

# Set enveronment variables for zsh
export DOT_DIR="$HOME/dotfiles"
export ZDOT_DIR="$HOME/dotfiles/.zsh"

# Config Golang
export GOPATH="$HOME/Golang"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Ruby
if (( $+commands[rbenv] )); then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# w3m
if (( $+commands[w3m] )); then
  export HTTP_HOME="google.com"
fi
