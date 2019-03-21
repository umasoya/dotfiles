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

# {{{1 load ${ZDOT_DIR}/*.zsh
for i in ${ZDOT_DIR}/*.zsh;do
  source ${i}
done
# }}}

# {{{1 zplug
# check init.zsh file
if [[ ! -f $HOME/.zplug/init.zsh ]]; then
  curl -sL --proto-redir -all,https "https://raw.githubusercontent.com/zplug/installer/master/installer.zsh"| zsh
fi
export ZPLUG_LOADFILE=$ZDOT_DIR/etc/plugins.zsh
source $HOME/.zplug/init.zsh

if ! zplug check; then
  zplug install
fi
# }}}
