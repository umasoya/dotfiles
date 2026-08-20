# 新規ファイル/ディレクトリのデフォルト権限を設定する
# for files: 666 - umask 022 = 644
# for directories: 777 - umask 022 = 755
umask 022

# load afx
source <(afx init)
# load afx completion
source <(afx completion zsh)

# enable autocomplete
autoload -U compinit
compinit

autoload -U +X bashcompinit && bashcompinit

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------
# Hook direnv
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

## fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  export FZF_COMPLETION_TRIGGER=''
  bindkey '^T' fzf-completion
  bindkey '^I' $fzf_default_completion
fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# -----------------------------------------------------------------------------
# Options
# -----------------------------------------------------------------------------
# vi mode
bindkey -v

# auto cd
setopt auto_cd

# beep
setopt no_beep
setopt no_list_beep
setopt no_hist_beep

# hist
setopt auto_pushd
setopt pushd_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space

# completion use glob
setopt extended_glob

# expand brace
setopt brace_ccl

# word split as bash
setopt sh_word_split

# notify when background job finished
setopt notify

# deploy valiables in prompt
setopt prompt_subst

# Consider # and later as comment
setopt interactive_comments

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
bindkey "^?" backward-delete-char

# reverse menu complete
bindkey '^[[Z' reverse-menu-complete

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
editor_ignore=(
  '~'
  '.DS_Store'
  '*.(jpg|jpeg|png|gif|pdf|xlsx|bak|docx|ico)'
  '*.(swp|tmp)'
)

zstyle ':completion:*:*:(vi|vim|less):*files' \
  ignored-patterns "${editor_ignore[@]}"

# Enable use cache
zstyle ':completion:*' use-cache true

# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Ignore completion matches pattern
zstyle ':completion:*:*:(vi|vim|less):*files' ignored-patterns ${editor_ignore}
# Ignore completion if selected parent dir
zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd
# if not exists target at current candidate target at parent dir
zstyle ':completion:*:(cd):*' tag-order local-directories path-directories
# Ignore already in the line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:(git add):*' ignore-line yes

# Completion man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-section true

# Completion kill command
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
editor_ignore=(
  '~'
  '.DS_Store'
  '*.(jpg|jpeg|png|gif|pdf|xlsx|bak|docx|ico)'
  '*.(swp|tmp)'
)

zstyle ':completion:*:*:(vi|vim|less):*files' \
  ignored-patterns "${editor_ignore[@]}"

# Enable use cache
zstyle ':completion:*' use-cache true

# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Ignore completion matches pattern
zstyle ':completion:*:*:(vi|vim|less):*files' ignored-patterns ${editor_ignore}
# Ignore completion if selected parent dir
zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd
# if not exists target at current candidate target at parent dir
zstyle ':completion:*:(cd):*' tag-order local-directories path-directories
# Ignore already in the line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:(git add):*' ignore-line yes

# Completion man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-section true

# Completion kill command
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
alias la='ls -a'
alias ll='ls -l'

alias grep='grep --color=auto -n'

alias reshell='exec ${SHELL} -l'
