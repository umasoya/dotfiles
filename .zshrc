# {{{ 基本オプション

# 文字コードはUTF-8 #
export LANG=ja_JP.UTF-8

# Googleライクにサジェスト #
setopt correct
#SPROMPT="( ´・ω・) ＜ もしかして: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
SPROMPT="( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
-> "

#入力したコマンドが存在せず、かつディレクトリ名と一致する場合ディレクトリに移動
setopt auto_cd

# ビープ音を鳴らさない
setopt no_beep

# 自動補完の有効化
autoload -U compinit; compinit

# 大文字小文字を区別せずに補完
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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

# }}}

# {{{ プロンプトの設定

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

# }}}

# {{{ ls coloring
#lsコマンドとzsh補完候補の色を揃える設定
# autoload colors
#colors

export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
'di=36' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# }}}

# w3m {{{
#webブラウザが起動していれば新規タブに開く
zstyle ':mime:*' browser-style running x
autoload -Uz pick-web-browser
alias -s html=pick-web-browser

#
# ホームページの設定
# これでv3mを引数なしで起動できる
#
export WWW_HOME="google.co.jp"
# }}}

#{{{ エイリアス

alias ...=`cd ../..` #　２つ上の階層に移動
alias ....=`cd ../../..` # ３つ上の階層に移動
alias ls="gls -F --color=auto"
alias la="ls -a"

alias -s html="open -a /Applications/Firefox.app"
alias index="~/Documents/terminal_command.html"

# カレントディレクトリのパスをクリップボードにコピー
alias path='echo -n `pwd` | pbcopy'

# richpager
alias rat="richpager -s friendly"
# }}}

# {{{ 関数
#
# cdしたら自動でls
# ファイルが多い場合は省略表示する
#

#function chpwd(){ ls }
chpwd() {
    ls_abbrev
}
ls_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

#
# catで常に行番号表示
#
catn(){
	\cat -n "$@"
}
alias cat="catn"

