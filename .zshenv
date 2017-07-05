# profiling
#zmodload zsh/zprof && zprof

# Do not regist duplicate path.
typeset -gx -U path

 #(N-/): Do not regist path if it is not exist.
path=(
	/usr/local/bin(N-/)
	/usr/bin(N-/)
	/usr/local/sbin(N-/)
	$HOME/local/bin(N-/)
	$path
)

# autoload
autoload -Uz add-zsh-hook
autoload -Uz terminfo
autoload -Uz vcs_info
autoload -Uz compinit; compinit
autoload -Uz colors && colors
autoload -Uz promptinit

# character-set  UTF-8
export LANG=ja_JP.UTF-8

# Editor
export EDITOR=vim
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
export DOTDIR="$HOME/dotfiles"
export ZDOT_DIR="$HOME/dotfiles/.zsh"

# Config Golang 
export GOPATH="$HOME/Golang"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
