#!/bin/bash

# Install solarized.vim

mkdir -p ~/.vim/colors 2>/dev/null
git clone https://github.com/altercation/vim-colors-solarized.git ~/.vim/colors/vim-colors-solarized/
mv ~/.vim/colors/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/solarized.vim
rm -rf ~/.vim/colors/vim-colors-solarized/ ~/.vim/colors/.git
