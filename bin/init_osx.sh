#!/bin/bash

# Install Xode command-line tool
sudo xcodebuild --license

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew update
brew update

# Install ansible
brew install ansible
