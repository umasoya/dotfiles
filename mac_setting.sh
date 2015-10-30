#!/bin/bash

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

# Use a custom theme （カスタムテーマを使う、そのテーマをデフォルトに設定する）
# Use a modified version of the Solarized Dark theme by default in Terminal.app
#	TERM_PROFILE='Solarized_Dark';
#	TERM_PATH='./';
# }}}
