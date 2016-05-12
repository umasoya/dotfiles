#!/usr/local/bin/zsh

#case "${OSTYPE}" in
#	*darwin*)
#		# OSX
#		Distribution="OSX"
#		;;
#	*linux*)
#		# Linux
#		detect_distribution
#		fi
#		;;
#esac

function detect_distribution(){
	Distribution=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'`
}

pwd=`pwd`
tmux display "Distribution: $Distribution"
tmux display $pwd
