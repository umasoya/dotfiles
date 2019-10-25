zplug mafredri/zsh-async, from:github
zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme
if zplug check "sindresorhus/pure"; then
  zstyle :prompt:pure:git:branch color magenta
  zstyle :prompt:pure:user color blue
  zstyle :prompt:pure:host color blue
fi

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", \
  defer:2, \
  from:github

zplug "b4b4r07/enhancd", use:init.sh
if zplug check "b4b4r07/enhancd"; then
  export ENHANCD_FILTER=`available_filter ${FILTER}`
  export ENHANCD_DOT_SHOW_FULLPATH=1
fi

zplug load --verbose 1>/dev/null
