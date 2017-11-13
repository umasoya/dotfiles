#!/bin/bash
#
#init-vagrant-ssh
#    usage: init-vagrant-ssh <host>
#

if [[ ${#} -eq 0 ]]; then
        echo -n "Please input host name: "
        read host
else
        host=${1}
fi

# if the host name is duplicated. do not anything
if [[ `grep "### ${host} ###" $HOME/.ssh/config` ]]; then
        echo "${host} is dupplicated"
        exit 1
else
        echo "### {$host} ###" >> ~/.ssh/config
        vagrant ssh-config --host ${host} >> ~/.ssh/config
        echo -e "\n" >> ~/.ssh/config
fi
