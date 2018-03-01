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
  if [[ ${i##*/} = init.zsh ]]; then
    continue
  fi
  source ${i}
done
# }}}

# {{{1 zplug
# check init.zsh file
if [[ -f $HOME/.zplug/init.zsh ]]; then
  export ZPLUG_LOADFILE=$ZDOT_DIR/init.zsh
  source $HOME/.zplug/init.zsh
else
  curl -sL --proto-redir -all,https "https://raw.githubusercontent.com/zplug/installer/master/installer.zsh"| zsh
  export ZPLUG_LOADFILE=$ZDOT_DIR/init.zsh
  source $HOME/.zplug/init.zsh
fi

if ! zplug check; then
  zplug install
fi
# }}}
