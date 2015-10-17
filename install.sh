#!/bin/bash

# =========================
#
## install.sh
## Deployment of dotfiles.
#
# How to use it
# 1. Repository clone to $HOME directory.
# 	$ git clone https://github.com/yasuto777/dotfiles.git
# 2. Run install.sh
# 	$ cd dotfiles && ./install.sh
# =========================

# {{{ Detect OS
detect_os(){
	export PLATFORM
	case "$(OSTYPE)" in
		*'darwin'*) PLATFORM='osx'	;;
		*'linux'*) PLATFORM='linux'	;;
	esac
}
# }}}
