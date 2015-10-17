#!/bin/bash
# ==============================================================
## install.sh
## 1. Deployment of dotfiles.
## 2. Update shell
## 3. Change default shell (osx=>newer zsh,linux=>newer bash).
#
#
## How to use it
## 1. Repository clone to $HOME directory.
## 	$ git clone https://github.com/yasuto777/dotfiles.git
## 2. Run install.sh
## 	$ cd dotfiles && ./install.sh
# ==============================================================

# {{{ Detect OS
detect_os(){
	export PLATFORM
	case "$(OSTYPE)" in
		*'darwin'*) PLATFORM='osx'	;;
		*'linux'*) PLATFORM='linux'	;;
	esac
}
detect_os
# }}}

# {{{ OS X

# Symlink to $HOME
./dotlink.sh

# Install Homebrew if not installed.
if ! type -p brew > /dev/null ; then
	echo ""
	echo "==========================="
	echo "Installing Homebrew!!"
	echo "==========================="
	echo ""
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew doctor
brew update

echo ""
echo "Finished Installing & updating Homebrew"
echo ""

# Update zsh
# brew install zsh



# }}}
