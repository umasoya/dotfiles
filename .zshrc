# 新規ファイル/ディレクトリのデフォルト権限を設定する
# for files: 666 - umask 022 = 644
# for directories: 777 - umask 022 = 755
umask 022

[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/brew.sh" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/brew.sh"
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/nix.sh" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/nix.sh"
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/env" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/env"

# load dircolors
[ -r "$DOT_DIR/sh/dircolors.sh" ] && . "$DOT_DIR/sh/dircolors.sh"

# -----------------------------------------------------------------------------
# Autoload
# -----------------------------------------------------------------------------
autoload -Uz add-zsh-hook
autoload -Uz terminfo
autoload -Uz colors && colors

# Completion files from the dedicated Nix profile.
if [[ -d "$XDG_STATE_HOME/nix/profiles/dotfiles/share/zsh/site-functions" ]]; then
    fpath=("$XDG_STATE_HOME/nix/profiles/dotfiles/share/zsh/site-functions" $fpath)
fi

# enable autocomplete
autoload -U compinit
compinit

autoload -U +X bashcompinit && bashcompinit

# -----------------------------------------------------------------------------
# Tools
# -----------------------------------------------------------------------------
# load afx
if (( $+commands[afx] )); then
    source <(afx init)
    source <(afx completion zsh)
fi

# Pure
RPROMPT='%F{242}%D{%H:%M:%S}%f'

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
# Apply the suggest even .dircolor
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

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

# Machine-specific interactive settings.
if [ -r "$HOME/.zshrc.local" ]; then
    . "$HOME/.zshrc.local"
fi
