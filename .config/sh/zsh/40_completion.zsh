binary_ext=\*.(jpg jpeg png gif pdf xlsx bak docx ico)
text_ignore=\*.(swp tmp)
editor_ignore=(~ .DS_Store ${binary_ext} ${text_ignore})

# Enable use cache
zstyle ':completion:*' use-cache true

# Enable autocomplete
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Ignore completion matches pattern
zstyle ':completion:*:*:(vi|vim|less):*files' ignored-patterns ${editor_ignore}
# Ignore completion if selected parent dir
zstyle ':completion:*:(cd|mv|cp|gitcd):*' ignore-parents parent pwd
# if not exists target at current candidate target at parent dir
zstyle ':completion:*:(cd|gitcd):*' tag-order local-directories path-directories
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
