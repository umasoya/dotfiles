os=`uname | tr '[:upper:]' '[:lower:]'`

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
  defer:2, \
  from:github

#zplug "stedolan/jq", \
#  as:command, \
#  from:gh-r, \
#  use:"*${os}*64*"
#  rename-to:"jq"
#
#zplug "direnv/direnv", \
#    as:command, \
#    from:gh-r, \
#    use:"*${os}*amd64*"
#    rename-to:"direnv"

#zplug "junegunn/fzf-bin", \
#  as:command, \
#  from:gh-r, \
#  rename-to:"fzf", \
#  frozen:1

zplug load --verbose 1>/dev/null
