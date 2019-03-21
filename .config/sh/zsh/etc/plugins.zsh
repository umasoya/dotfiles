zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
  defer:2, \
  from:github

zplug load --verbose 1>/dev/null
