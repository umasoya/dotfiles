#!/bin/bash

# Install solarized.vim

mkdir -p ~/.vim/colors
git clone https://github.com/altercation/vim-colors-solarized.git ~/.vim/colors/
mv ~/.vim/colors/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/solarized.vim
rm -rf ~/.vim/colors/vim-colors-solarized
