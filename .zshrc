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

export DISTRIBUTION
function detect_distribution(){
	DISTRIBUTION=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'` 2>/dev/null
}

case "${OSTYPE}" in
	*darwin*)
		# OSX
		DISTRIBUTION="osx"
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

is_mac() {
        if [[ DISTRIBUTION == "osx" ]]; then
                return 0
        else
                return 1
        fi
}
alias is_osx=is_mac
# }}}

# {{{ load ${ZDOT_DIR}/*.zsh
for i in ${ZDOT_DIR}/*.zsh;do
  source ${i}
done

if [[ -f ${DOT_DIR}/.local_config/zsh/*.zsh ]]; then
  for i in ${DOT_DIR}/.local_config/zsh/*.zsh; do
    source ${i}
  done
fi
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
