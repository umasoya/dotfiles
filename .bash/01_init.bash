if [[ ! -f ~/dotfiles/.bash/.bash-preexec.sh ]]; then
  curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/dotfiles/.bash/.bash-preexec.sh
fi
source ~/dotfiles/.bash/.bash-preexec.sh

# color
export LS_COLOR=GxFxCxDxBxegedabagacad
if [ -f ~/.dircolors ];then
  if type dircolors > /dev/null 2>&1; then
    eval $(dircolors ~/.dircolors)
  elif type gdircolors > /dev/null 2>&1; then
    eval $(gdircolors ~/.gdircolors)
  fi
fi

# prompt
PS1="\n\[\e[0;36m\]\h@\u\n[\w]\[\e[00m\] \$ "

# TAB completion
bind TAB:menu-complete
