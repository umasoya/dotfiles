# history ignore
# zshaddhistory() {
#   local line cmd line=${1%%$'\n'}
#   local cmd=${line%% *}
#
#   # 以下の条件をすべて満たすものだけをヒストリに追加する
#   [[ ${#line} -ge 5
#   && ${cmd} != (l|l[sal])
#   && ${cmd} != (c|cd)
#   && ${cmd} != (m|man)
#   ]]
#
# }
