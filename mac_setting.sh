#!/bin/bash

# {{{1 Dock

# Automatically hide or show the Dock
defaults write com.apple.dock autohide -bool true

# }}}

# {{{1 Finder

	# Show Status-bar in Finder
	defaults write com.apple.finder ShowStatusBar -bool true

	# Show Tab-bar in Finder
	defaults write com.apple.finder ShowTabView -bool true

	# Show the ~/Library directory
	chflags nohidden ~/Library

	# Show the hidden files
	defaults write com.apple.finder AppleShowAllFiles YES
# }}}

# {{{1 Terminal.app

## Use a custom theme （Use Custom theme, and use it default）
## Use a modified version of the Solarized Dark theme by default in Terminal.app
#	TERM_PROFILE='Solarized_Dark';
## *.terminal path
#	TERM_PATH='./';

# }}}

# {{{1 TrackPad

# Enable to 'tap to click'
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# }}}
