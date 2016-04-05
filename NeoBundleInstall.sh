#!/bin/bash

function detect_distribution(){
	distribution=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'`
}

function git_install(){
	case "$distribution" in
		*darwin* )
			#OSX
			brew install git;;
		*linux*)
			#Ubuntu
			apt-get install git;;
	esac
}


if [ ! -e ~/.vim/bundle ];then
	mkdir -p ~/.vim/bundle
fi

if type "git" > /dev/null 2>&1;then
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
else 
	# Processing for each OS
	git_install
	git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

vim +":NeoBundleInstall" +:q
