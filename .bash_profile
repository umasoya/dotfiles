# {{{1 When used ChromeOS and installed zsh, run zsh
if [[ -f /etc/os-release ]]; then
    destribution=`awk -F= NR==2{print\ $2} /etc/os-release`
    if [[ "${destribution}" = "Chrome OS" ]] && type zsh; then
        exec zsh
    fi
fi
# }}}

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

# {{{1 Golang
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
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
[[ -s $NVM_DIR/nvm.sh ]] && \. "NVM_DIR/nvm.sh"
# }}}
