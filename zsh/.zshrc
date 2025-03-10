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

# load afx
source <(afx init)
# load afx completion
source <(afx completion zsh)

# {{{1 load ${ZDOT_DIR}/*.zsh
for i in ${ZDOT_DIR}/*.zsh;do
  source ${i}
done
# }}}

# enable autocomplete
autoload -U compinit
compinit

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
