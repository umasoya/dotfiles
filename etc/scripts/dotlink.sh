#!/bin/bash
## Make Synbolic-link to $HOME
# ln -s <source> <target>

set -eux

files="$HOME/dotfiles/.??*"
# Make array
dotfile=()

# Distinguish file or directory
for i in $files; do
	if [ -f $i ]; then
		dotfile+=("$i")
	fi
done

dotfile+=("$HOME/dotfiles/.vim")

# Make Synbolic-link
for n in ${dotfile[@]}; do
  # Don't create link .git*
  if [[ $n =~ \.git* ]];then
    continue
  fi

	filename=`basename $n`
	ln -s -f $n $HOME/$filename
done

# Common configs on local
gitconfigs="$HOME/dotfiles/etc/.??*"
for i in ${gitconfigs}; do
  filename=`basename ${i}`
  ln -s -f ${i} $HOME/${filename}
done
