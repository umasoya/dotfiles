#                                                          
#                                                          
#                               ,---,                      
#                             ,--.' |                      
#             ,----,          |  |  :      __  ,-.         
#           .'   .`| .--.--.  :  :  :    ,' ,'/ /|         
#        .'   .'  .'/  /    ' :  |  |,--.'  | |' | ,---.   
#      ,---, '   ./|  :  /`./ |  :  '   ||  |   ,'/     \  
#      ;   | .'  / |  :  ;_   |  |   /' :'  :  / /    / '  
#      `---' /  ;--,\  \    `.'  :  | | ||  | ' .    ' /   
#        /  /  / .`| `----.   \  |  ' | :;  : | '   ; :__  
# ___  ./__;     .' /  /`--'  /  :  :_:,'|  , ; '   | '.'| 
#/  .\ ;   |  .'   '--'.     /|  | ,'     ---'  |   :    : 
#\  ; |`---'         `--'---' `--''              \   \  /  
# `--"                                            `----'   
#                                                          

# {{{1 Detect OSTYPE

case "${OSTYPE}" in
	*darwin*)
		# OSX
		OS=OSX
		source .zsh/.zshrc_osx
		;;
	*linux*)
		# Linux
		export OS=Linux
		;;
esac
# }}}


# zsh起動時にtmux起動
[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

# 文字コードはUTF-8 #
export LANG=ja_JP.UTF-8

#プロンプトの自動リロード
autoload -U promptinit
promptinit
autoload -U colors && colors

autoload -Uz dd-zsh-hook
autoload -Uz terminfo

#  Vim mode setting
bindkey -v

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


# {{{2 catn
#
# catで常に行番号表示
#
catn(){
	\cat -n "$@"
}
 alias cat="catn"
# }}}

# {{{ update Brewfile
# Automatically update Brewfile when execute a  brew command
if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi
# }}}

# {{{ rbenv
if [ -d ${HOME}/.rbenv ]; then
	PATH=${HOME}/.rbenv/bin:${PATH}
	export PATH
	eval "$(rbenv init -)"
fi
# }}}

# {{{2 Prompt

# 直前の返り値によって色変更
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"

#スクリーン番号を（あれば）変数に格納
local window_no="${WINDOW:+"[$WINDOW]"}"

PROMPT="
%{$fg[cyan]%}User:%n%{${reset_color}%}
$p_color [%~] > %{${reset_color}%}"

# Googleライクにサジェスト #
setopt correct
SPROMPT="( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
-> "

# {{{3 vcs_info

autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:git:*' formats "%F{green}[%b]%c%u%f"
zstyle ':vcs_info:git:*' actionformats '[%b | %a]'
precmd(){ vcs_info }
# }}}

# {{{3 function_memo
function memo(){
	if [ $# -eq 0 ]; then
		unset memotxt
		return
	fi
for str in $@
do
	memotxt="${memotxt} ${str}"
done
}
# }}}

RPROMPT='%S${memotxt}%s''${vcs_info_msg_0_}'"$p_color return:[%?]%{${reset_color}%} "

# }}}

# {{{2 ls coloring
#lsコマンドとzsh補完候補の色を揃える設定

export LSCOLORS=gxfxcxdxbxegedabagacad
if [ -f ~/.dircolors ]; then
    if type dircolors > /dev/null 2>&1; then
        eval $(dircolors ~/.dircolors)
    elif type gdircolors > /dev/null 2>&1; then
        eval $(gdircolors ~/.dircolors)
    fi
fi

# Apply the suggest even .dircolor
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi
# }}}

# {{{2 w3m
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

# }}}

 #{{{1 alias

alias ...=`cd ../..` #　２つ上の階層に移動
alias ....=`cd ../../..` # ３つ上の階層に移動
alias la="ls -a"

# カレントディレクトリのパスをクリップボードにコピー
alias path='echo -n `pwd` | pbcopy'

# }}}

