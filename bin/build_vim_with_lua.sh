#!/bin/bash

# installl ncurses, lua
yum install -y ncurses-devel lua-devel

git clone https://github.com/vim/vim.git $HOME
./$HOME/vim/configure --enable-luainterp
$HOME/vim/make
$HOME/vim/make install

rm -rf $HOME/vim/
