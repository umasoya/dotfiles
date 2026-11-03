# 共通環境変数の読み込み
[ -r "${DOT_DIR:-$HOME/dotfiles}/sh/env" ] && . "${DOT_DIR:-$HOME/dotfiles}/sh/env"

# PATHの重複を除去する
typeset -gxU path
