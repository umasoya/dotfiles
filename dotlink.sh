#!/bin/bash
## Make Synbolic-link to $HOME
# ln -s <source> <target>

files="$HOME/dotfiles/.??*"
# Make array
dotfile=()

# Distinguish file or directory
for i in $files; do
	if [ -f $i ]; then
		dotfile+=("$i")
	fi
done

# Make Synbolic-link
for n in ${dotfile[@]}; do
	filename=`basename $n`
	ln -s -f $n $HOME/$filename
done
