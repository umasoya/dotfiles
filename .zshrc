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

### Added by Zinit's installer
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

# load zinit config
source ${ZDOT_DIR}/etc/zinit.zsh
autoload -U compinit
compinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
