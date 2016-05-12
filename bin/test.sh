#!/bin/bash

function detect_distribution(){
	Distribution=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'`
}

case "${OSTYPE}" in
	*darwin*)
		# OSX
		Distribution="OSX"
		source "${ZDOT_DIR}/.zshrc_osx"
		;;
	*linux*)
		# Linux
		detect_distribution
		if [ -f ${ZDOT_DIR}/.zshrc_${DISTRIBUTION} ]; then
		source ${ZDOT_DIR}/.zshrc_${DISTRIBUTION}
		fi
		;;
esac
export Distribution

#function test() {
#	echo "$distribution"
#}
tmux display "DISTRIBUTION: $DISTRIBUTION"
#tmux display "$1"
