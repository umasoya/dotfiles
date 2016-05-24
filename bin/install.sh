#!/bin/bash
# ==============================================================
## install.sh
## 1. Deployment of dotfiles.
## 2. Update shell
## 3. Change default shell (osx=>newer zsh,linux=>newer bash).
## 4. install github && setting rsa_key&ID
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
		*)			PLATFORM='unknown'	;;
	esac
}
detect_os
# }}}

# {{{ OS X

# {{{2 Install Homebrew if not installed.
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
# }}}

## Update zsh to /usr/local/bin/zsh
## Change login shell bash => newer zsh

# Install brew-file if not install.


# }}}
