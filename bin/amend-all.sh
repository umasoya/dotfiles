#!/bin/bash

#
## Change all author and commiter of past commit.
#

while [ -z "${author}" ]
do
    read -p "author: " author
done;

while [ -z "${email}" ]
do
    read -p "email: " email
done;

echo -e "\e[33;40m${author} <${email}>\e[m"

while :
do
    read -p "Is this OK? (y/n): " yn
    case ${yn} in
        "y" | "Y" )
            git filter-branch -f --env-filter "GIT_AUTHOR_NAME=\'${author}\';GIT_AUTHOR_EMAIL=\'${email}\'; GIT_COMMITTER_NAME=\'${author}\'; GIT_COMMITTER_EMAIL=\'${email}\';" HEAD
            break ;;
        "n" | "N" )
            echo "Canceled."
            break ;;
    esac
done
