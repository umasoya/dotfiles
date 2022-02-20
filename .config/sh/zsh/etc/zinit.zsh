# zsh-completions
# -------------------------------
# zinit ice wait lucid blockf atpull'zplugin creinstall -q .'
# zinit light zsh-users/zsh-completions

# git completions
# -------------------------------
# zinit ice lucid as"completion"
# zinit snippet https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

# docker completions
# -------------------------------
# zinit ice lucid as"completion"
# zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

# 
# # zsh-autosuggestions
# # -------------------------------
# zinit ice wait lucid atload"_zsh_autosuggest_start"
# zinit light zsh-users/zsh-autosuggestions
# 
# # pure
# # -------------------------------
# zstyle :prompt:pure:git:branch color magenta
# zstyle :prompt:pure:git:branch:cached color yellow
# zstyle :prompt:pure:git:dirty color 091
# zstyle :prompt:pure:user color blue
# zstyle :prompt:pure:host color blue
# 
# zinit ice pick"async.zsh" src"pure.zsh" atclone"npm install --global pure-prompt"
# zinit light sindresorhus/pure
# 
# # pt
# # -------------------------------
# zinit ice as"program" from"gh-r" bpick"${BPICK}" pick"*/pt"
# zinit load monochromegane/the_platinum_searcher
# 
# # cheat
# # -------------------------------
# zinit ice as"program" from"gh-r" bpick"${BPICK}" mv"cheat-* -> cheat"
# zinit load cheat/cheat
# 
# # ccat
# # -------------------------------
# zinit ice lucid as"program" from"gh-r" bpick"${BPICK}" pick"*/ccat" atload"alias cat=ccat"
# zinit light owenthereal/ccat
# 
# # tmux-xpanes
# # -------------------------------
# zinit ice lucid as"program" pick"bin/*"
# zinit light greymd/tmux-xpanes
