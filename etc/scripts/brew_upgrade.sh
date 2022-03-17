#!/bin/bash

set -eux

cd "${HOME}/dotfiles/brew"

/opt/homebrew/bin/brew upgrade
/opt/homebrew/bin/brew upgrade --cask
/opt/homebrew/bin/mas upgrade

/opt/homebrew/bin/brew bundle dump -f
