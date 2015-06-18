#-----プロンプトの設定-----#

#プロンプトの自動リロード
autoload -U promptinit
promptinit
autoload -U colors && colors

#ユーザーIDでマーク変更
local p_mark="%B%(?,%F{green},%F{magenta})%(!,#,>)%f%b"

#スクリーン番号を（あれば）変数に格納
local window_no="${WINDOW:+"[$WINDOW]"}"


PROMPT="
%{$F[green]%}User:%n%{${reset_color}%}
%(?.%{${fg[green]}%}.%{${fg[magenta]}%})[%~]%{${reset_color}%} $p_mark "
RPROMPT="[%*] %{$fg[cyan]%}return:[%?]%{$reset_color%}"
#RPROMPT="%{$fg[cyan]%}return:[%?]%{$reset_color%}"
#--------------------------#

# 自動補完の有効化
autoload -U compinit; compinit


# 大文字小文字を区別せずに補完
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

#入力したコマンドが存在せず、かつディレクトリ名と一致する場合ディレクトリに移動
setopt auto_cd

#移動先ディレクトリをスタック(履歴)に追加する
setopt auto_pushd
#ディレクトリがすでにスタックに含まれていればスタックに追加しない
setopt pushd_ignore_dups

#拡張glob(パス名にマッチするワイルドカードパターン)の有効化
setopt extended_glob

# 入力したコマンドがすでにコマンド履歴に含まれる場合、履歴から古いほうのコマンドを削除する
# コマンド履歴とは今まで入力したコマンドの一覧のことで、上下キーでたどれる
setopt hist_ignore_all_dups

# コマンドがスペースで始まる場合、コマンド履歴に追加しない
setopt hist_ignore_space

#<tab>でパス名の補完候補を表示後、続けて<tab>を押すと候補からパス名を選択できるようにする
zstyle ':completion:*:default' menu select=1

#lsコマンドとzsh補完候補の色を揃える設定
autoload colors
colors

export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

#webブラウザが起動していれば新規タブに開く
zstyle ':mime:*' browser-style running x
autoload -Uz pick-web-browser
alias -s html=pick-web-browser

#---------エイリアス-----------#
alias ...=`cd ../..` #　２つ上の階層に移動
alias ....=`cd ../../..` # ３つ上の階層に移動
alias ls="gls -F --color=auto"
#alias ls="ls -F"
alias la="ls -a"
alias -s html="open -a /Applications/Firefox.app"
alias index="~/Documents/terminal_command.html"
#------------------------------#

cdls(){
	\cd "$@" && la
}
alias cd="cdls"


