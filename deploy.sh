#!/bin/bash

set -eu

# Reset Color
COLOR_OFF="\033[m"
# Green
COLOR_GREEN="\033[32m"

TARGETS=(
  config
  git
  misc
  mysql
  pt
  tmux
  vim
  zsh
)

echo -e "${COLOR_GREEN}Start deploying dotfiles... ${COLOR_OFF}"

# Run Deploy
stow -vR ${TARGETS[@]}
# For mac VSCode
if [[ -d "~/Library/Application\ Support/Code/User/ code" ]]; then
  stow -vR -t ~/Library/Application\ Support/Code/User/ code
fi

echo -e "${COLOR_GREEN}Finish deploying dotfiles‼️ ${COLOR_OFF}"

# Error Handling
on_err(){
  error_code=$1
  line_num=$2
  message=$3
  errmsg=
  errmsg+="----------------------------\n"
  errmsg+="Error Code : ${error_code}\n"
  errmsg+="Message : ${message}\n"
  errmsg+="Command Line : ${line_num}\n"
  errmsg+="----------------------------\n"
  echo -e ${errmsg}
  exit ${error_code}
}
trap 'on_err $? $LINENO "$MESSAGE"' ERR
