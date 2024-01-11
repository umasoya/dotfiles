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
