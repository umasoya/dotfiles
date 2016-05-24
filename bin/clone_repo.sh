#!/bin/bash

# Cloning repositories from Github
# Repositories list is '~/dotfiles/etc/Repository_list'

Repo_list="../etc/Repository_list"

while read user repo; do
	echo ${user} | grep -v '^#.*' > /dev/null
	if [ $? -eq 0 ];then
		echo "${user} ${repo}"
	fi
	#git clone https://github.com/${user}/${repo}
done < $Repo_list

