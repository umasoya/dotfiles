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

# {{{1 nvim
export XDG_CONFIG_HOME="$HOME/.config"
# }}}

# Editor
if (( $+commands[nvim] )); then
  export EDITOR=nvim
elif (( $+commands[vim] ));then
  export EDITOR=vim
fi
export GIT_EDITOR=${EDITOR}

# Pager
export PAGER=less

# {{{ ls coloring
export LSCOLORS=gxfxcxdxbxegedabagacad
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

# {{{1 Golang
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
# }}}

# {{{1 Ruby
if (( $+commands[ruby] )); then
  if [[ ! -d $HOME/.rbenv ]]; then
    git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
  fi
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
# }}}

# {{{1 Python
if [[ ! -d $HOME/.pyenv ]]; then
    git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# }}}

# {{{1 nvm
if [[ ! -d $HOME/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | PROFILE=/dev/null bash
fi
export NVM_DIR="$HOME/.nvm"
[[ -s $NVM_DIR/nvm.sh ]] && \. "$NVM_DIR/nvm.sh"
# }}}

# {{{1 w3m
if (( $+commands[w3m] )); then
  export HTTP_HOME="google.com"
fi
# }}}
