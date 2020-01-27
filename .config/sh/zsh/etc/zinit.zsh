if [ "$(uname -s)" = 'Linux' ]; then
  BPICK="(*linux*64)|(*linux*amd*)"
else
  BPICK="(*darwin*)|(*Darwin*)|(*osx*)"
fi

# zinit (zplugin)
# -------------------------------
if [[ ! -d $HOME/.zinit ]]; then
  mkdir $HOME/.zinit
  git clone  https://github.com/zdharma/zinit.git ~/.zinit/bin
fi

# zsh-completions
# -------------------------------
zplugin ice wait lucid blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions

# docker completions
# -------------------------------
zplugin ice lucid as"completion"
zplugin snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# docker-compose
# -------------------------------
zplugin ice lucid from"gh-r" as"program" mv"docker* -> docker-compose" bpick"${BPICK}"
zplugin load docker/compose

# zsh-autosuggestions
# -------------------------------
zplugin ice wait lucid atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions

# fast-syntax-highlighting
# -------------------------------
zplugin ice wait lucid atinit"zpcompinit; zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

# pure
# -------------------------------
zstyle :prompt:pure:git:branch color magenta
zstyle :prompt:pure:git:branch:cached color yellow
zstyle :prompt:pure:git:dirty color 091
zstyle :prompt:pure:user color blue
zstyle :prompt:pure:host color blue

zplugin ice pick"async.zsh" src"pure.zsh" atclone"npm install --global pure-prompt"
zplugin light sindresorhus/pure


# direnv
# -------------------------------
zplugin ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zplugin light direnv/direnv

# fzf
# -------------------------------
zplugin pack for fzf

# jq
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" mv"jq-* -> jq"
zplugin load stedolan/jq

# ghq
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" pick"*/ghq"
zplugin load motemen/ghq

# hub
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" pick"*/bin/hub"
zplugin light github/hub
zplugin ice wait lucid as"completion" from"gh-r" id-as"hub-completion" \
  mv"hub*/etc/hub.zsh_completion -> _hub" pick"_hub"

# pt
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" pick"*/pt"
zplugin load monochromegane/the_platinum_searcher

# cheat
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" mv"cheat-* -> cheat"
zplugin load cheat/cheat

# enhancd
# -------------------------------
zplugin ice lucid as"program" pick"init.sh" \
  atload'export ENHANCD_FILTER=`available_filter ${FILTER}`; export ENHANCD_DOT_SHOW_FULLPATH=1'
zplugin light b4b4r07/enhancd

# ccat
# -------------------------------
zplugin ice lucid as"program" from"gh-r" bpick"${BPICK}" pick"*/ccat" atload"alias cat=ccat"
zplugin light jingweno/ccat

# tmux-xpanes
# -------------------------------
zplugin ice lucid as"program" pick"bin/*"
zplugin light greymd/tmux-xpanes
