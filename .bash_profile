# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

export XDG_CONFIG_HOME=$HOME/.config

export EDITOR=vim
export GIT_EDITOR=vim
export PAGER=less

# User specific environment and startup programs
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/dotfiles/bin

# Go
export GOPATH=$HOME/Golang
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Ruby
if [[ -d $HOME/.rbenv ]] && type ruby >/dev/null 2>&1
then
  export PATH=$PATH:$HOME/.rbenv/bin
  eval "$(rbenv init -)"
fi

# w3m
if type w3m > /dev/null 2>&1
then
  export HTTP_HOME="google.com"
fi
