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
