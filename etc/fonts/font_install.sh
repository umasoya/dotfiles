#!/bin/zsh
# Install CUI fonts

cp -f $HOME/dotfiles/etc/fonts/* /Library/Fonts/
fc-cache -vf
