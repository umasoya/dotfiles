zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
  defer:2, \
  from:github

# zplug "b4b4r07/enhancd", use:init.sh
# if zplug check "b4b4r07/enhancd"; then
#         export ENHANCD_FILTER="fzf --height 50% --reverse --ansi"
#         export ENHANCD_DOT_SHOW_FULLPATH=1
# fi

zplug "stedolan/jq", \
  as:command, \
  from:gh-r, \
  rename-to:"jq"

zplug "junegunn/fzf-bin", \
  as:command, \
  from:gh-r, \
  rename-to:"fzf", \
  frozen:1

zplug load
