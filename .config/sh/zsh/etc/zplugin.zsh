if [ "$(uname -s)" = 'Linux' ]; then
  BPICK="(*linux*64)|(*linux*amd*)"
else
  BPICK="(darwin)|(*Darwin*)|(*osx*)"
fi

# zsh-completions
# -------------------------------
zplugin ice wait blockf atpull'zplugin creinstall -q .'
zplugin light zsh-users/zsh-completions

# zsh-autosuggestions
# -------------------------------
zplugin ice wait atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions

# fast-syntax-highlighting
# -------------------------------
zplugin ice wait atinit"zpcompinit; zpcdreplay"
zplugin light zdharma/fast-syntax-highlighting

# pure
# -------------------------------
zstyle :prompt:pure:git:branch color magenta
zstyle :prompt:pure:git:branch:cached color yellow
zstyle :prompt:pure:git:dirty color 091
zstyle :prompt:pure:user color blue
zstyle :prompt:pure:host color blue

zplugin ice pick"async.zsh" src"pure.zsh"
zplugin light sindresorhus/pure


# direnv
# -------------------------------
zplugin ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zplugin light direnv/direnv

# fzf
# -------------------------------
zplugin ice from"gh-r" as"program"
zplugin load junegunn/fzf-bin

# docker-compose
# -------------------------------
zplugin ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"${BPICK}"
zplugin load docker/compose

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

# pt
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" pick"*/pt"
zplugin load monochromegane/the_platinum_searcher

# cheat
# -------------------------------
zplugin ice as"program" from"gh-r" bpick"${BPICK}" mv"cheat-* -> cheat"
zplugin load cheat/cheat
