#!/bin/bash

set -eu

cd "${HOME}/dotfiles/brew"

/opt/homebrew/bin/brew upgrade
/opt/homebrew/bin/brew upgrade --cask
if [[ `/opt/homebrew/bin/mas outdated` != '' ]]; then
  echo 'update exists.'
  /opt/homebrew/bin/mas upgrade
fi

/opt/homebrew/bin/brew bundle dump -f

exit 0
