if [ "$(uname -s)" = 'Linux' ]; then
  BPICK="(*linux*64)|(*linux*amd*)"
else
  BPICK="(*darwin*)|(*Darwin*)|(*osx*)"
fi

# zinit (zplugin)
# -------------------------------
if [[ ! -d $HOME/.zinit ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

# zsh-completions
# -------------------------------
zinit ice wait lucid blockf atpull'zplugin creinstall -q .'
zinit light zsh-users/zsh-completions

# git completions
# -------------------------------
zinit ice lucid as"completion"
zinit snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

# docker completions
# -------------------------------
zinit ice lucid as"completion"
zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# docker-compose
# -------------------------------
zinit ice lucid from"gh-r" as"program" mv"docker* -> docker-compose" bpick"${BPICK}"
zinit load docker/compose

# zsh-autosuggestions
# -------------------------------
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# fast-syntax-highlighting
# -------------------------------
zinit ice wait lucid atinit"zpcompinit; zpcdreplay"
zinit light zdharma/fast-syntax-highlighting

# pure
# -------------------------------
zstyle :prompt:pure:git:branch color magenta
zstyle :prompt:pure:git:branch:cached color yellow
zstyle :prompt:pure:git:dirty color 091
zstyle :prompt:pure:user color blue
zstyle :prompt:pure:host color blue

zinit ice pick"async.zsh" src"pure.zsh" atclone"npm install --global pure-prompt"
zinit light sindresorhus/pure


# direnv
# -------------------------------
zinit ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zinit light direnv/direnv

# fzf
# -------------------------------
zinit pack for fzf

# jq
# -------------------------------
zinit ice as"program" from"gh-r" bpick"${BPICK}" mv"jq-* -> jq"
zinit load stedolan/jq

# ghq
# -------------------------------
#zplugin ice as"program" from"gh-r" bpick"${BPICK}" pick"*/ghq"
#zplugin load motemen/ghq

# hub
# -------------------------------
zinit ice as"program" from"gh-r" bpick"${BPICK}" pick"*/bin/hub"
zinit light github/hub
zinit ice wait lucid as"completion" from"gh-r" id-as"hub-completion" \
  mv"hub*/etc/hub.zsh_completion -> _hub" pick"_hub"

# pt
# -------------------------------
zinit ice as"program" from"gh-r" bpick"${BPICK}" pick"*/pt"
zinit load monochromegane/the_platinum_searcher

# cheat
# -------------------------------
zinit ice as"program" from"gh-r" bpick"${BPICK}" mv"cheat-* -> cheat"
zinit load cheat/cheat

# enhancd
# -------------------------------
zinit ice as"program" src"init.sh" \
  atload'export ENHANCD_FILTER=`available_filter ${FILTER}`; export ENHANCD_DOT_SHOW_FULLPATH=1'
zinit load b4b4r07/enhancd

# ccat
# -------------------------------
zinit ice lucid as"program" from"gh-r" bpick"${BPICK}" pick"*/ccat" atload"alias cat=ccat"
zinit light jingweno/ccat

# tmux-xpanes
# -------------------------------
zinit ice lucid as"program" pick"bin/*"
zinit light greymd/tmux-xpanes
