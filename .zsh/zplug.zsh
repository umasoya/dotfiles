# check init.zsh file
if [[ -f $HOME/.zplug/init.zsh ]]; then
  export ZPLUG_LOADFILE=$HOME/dotfiles/.zsh/.zplugrc
  source $HOME/.zplug/init.zsh
else
  curl -sL --proto-redir -all,https "https://raw.githubusercontent.com/zplug/installer/master/installer.zsh"| zsh
  export ZPLUG_LOADFILE=$HOME/dotfiles/.zsh/.zplugrc
  source $HOME/.zplug/init.zsh
fi

# If `zplug check` is false, run `zplug install`
if ! zplug check; then
  zplug install
fi

if [ -e $ZPLUG_REPOS/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $ZPLUG_REPOS/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
