#!/bin/bash

# Cloning repositories from Github
# Repositories list is '$HOME/dotfiles/etc/Repository_list'

Repo_list="$HOME/dotfiles/etc/Repository_list"

#echo $PWD;cd $WORKING_DIR;echo $PWD

while read user repo into_path; do
	if [[ ${user} =~ ^[^#\s].* ]];then
		#echo "https://github.com/${user}/${repo} -> $PWD"
		eval git clone https://github.com/${user}/${repo}.git $into_path &
	fi
done < $Repo_list

wait

exit
