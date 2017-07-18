#                                                          
#                                                          
#                               ,---,                      
#                             ,--.' |                      
#             ,----,          |  |  :      __  ,-.         
#           .'   .`| .--.--.  :  :  :    ,' ,'/ /|         
#        .'   .'  .'/  /    ' :  |  |,--.'  | |' | ,---.   
#      ,---, '   ./|  :  /`./ |  :  '   ||  |   ,'/     \  
#      ;   | .'  / |  :  ;_   |  |   /' :'  :  / /    / '  
#      `---' /  ;--,\  \    `.'  :  | | ||  | ' .    ' /   
#        /  /  / .`| `----.   \  |  ' | :;  : | '   ; :__  
# ___  ./__;     .' /  /`--'  /  :  :_:,'|  , ; '   | '.'| 
#/  .\ ;   |  .'   '--'.     /|  | ,'     ---'  |   :    : 
#\  ; |`---'         `--'---' `--''              \   \  /  
# `--"                                            `----'   
#                                                          

umask 022

# {{{1 Detect OSTYPE

function detect_distribution(){
	distribution=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'` 2>/dev/null
}

case "${OSTYPE}" in
	*darwin*)
		# OSX
		distribution="OSX"
		source "${ZDOT_DIR}/.zshrc_osx"
		;;
	*linux*)
		# Linux
		detect_distribution
		if [ -f ${ZDOT_DIR}/.zshrc_${distribution} ]; then
		source ${ZDOT_DIR}/.zshrc_${distribution}
		fi
		;;
esac
# }}}

# {{{ load ${ZDOT_DIR}/*.zsh
for i in ${ZDOT_DIR}/*.zsh;do
  source ${i}
done
# }}}

# {{{ profiling
# If you want to profiling zsh configuration, load zprof moduele in .zshenv
# Later than zsh ver 5.0.7
if type "zprof" > /dev/null 2>&1; then
  if [ ! -d "$HOME/.zsh-profiles" ];then
    mkdir "$HOME/.zsh-profiles"
  fi
  zprof > "$HOME/.zsh-profiles/profile_`date '+%F_%T'`"
fi
# }}}
