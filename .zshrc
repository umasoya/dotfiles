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

# Environment variables
export DOTDIR="$HOME/dotfiles"
export ZDOT_DIR="$HOME/dotfiles/.zsh"

# {{{1 Detect OSTYPE

function detect_distribution(){
	distribution=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'` 2>/dev/null
}

case "${OSTYPE}" in
	*darwin*)
		# OSX
		distribution="OSX"
		source "${ZDOT_DIR}/.zshrc_osx"
		;;
	*linux*)
		# Linux
		detect_distribution
		if [ -f ${ZDOT_DIR}/.zshrc_${distribution} ]; then
		source ${ZDOT_DIR}/.zshrc_${distribution}
		fi
		;;
esac
# }}}

# {{{1 General settings
# Auto launch tmux if it installed
#[[ -z "$TMUX" && ! -z "$PS1" ]] && tmux

# character-set  UTF-8
export LANG=ja_JP.UTF-8

# auto reload prompt
autoload -U promptinit
promptinit
autoload -U colors && colors

autoload -Uz dd-zsh-hook
autoload -Uz terminfo

#  Vim mode setting
bindkey -v

# If the command does not exist and matches Dir name, move to Dir
setopt auto_cd

# no beep
setopt no_beep

# Enable autocomplete
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

#
# catで常に行番号表示
#
catn(){
	\cat -n "$@"
}
 alias cat="catn"
# }}}

# {{{ zplug
# check init.zsh file
if [ -e $HOME/.zplug/init.zsh ]; then
  source $HOME/.zplug/init.zsh
else
  curl -sL --proto-redir -all,https "https://raw.githubusercontent.com/zplug/installer/master/installer.zsh"| zsh
  source $HOME/.zplug/init.zsh
fi

# Load .zplugrc
source $HOME/dotfiles/.zplugrc

# If `zplug check` is false, run `zplug install`
if ! zplug check; then
  zplug install
fi

if [ -e $ZPLUG_REPOS/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $ZPLUG_REPOS/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# }}}

# {{{1 Prompt

# 直前の返り値によって色変更
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"

#スクリーン番号を（あれば）変数に格納
local window_no="${WINDOW:+"[$WINDOW]"}"

PROMPT="
%{$fg[cyan]%}%n@%m%{${reset_color}%} $github_status
$p_color [%~] > %{${reset_color}%}"

# Googleライクにサジェスト #
setopt correct
SPROMPT="( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
-> "

# {{{2 vcs_info

autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:git:*' formats "%F{green}[%b]%c%u%f"
zstyle ':vcs_info:git:*' actionformats '[%b | %a]'
precmd(){ vcs_info }
# }}}

# {{{2 function_memo
#function memo(){
#	if [ $# -eq 0 ]; then
#		unset memotxt
#		return
#	fi
#for str in $@
#do
#	memotxt="${memotxt} ${str}"
#done
#}
# }}}


#RPROMPT='%S${memotxt}%s''${vcs_info_msg_0_}'"$p_color return:[%?]%{${reset_color}%} "
RPROMPT='${vcs_info_msg_0_}'"$p_color return:[%?]%{${reset_color}%} "

# }}}

# {{{1 ls coloring
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

# {{{1 w3m
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

 #{{{1 alias

alias ...=`cd ../..` #　２つ上の階層に移動
alias ....=`cd ../../..` # ３つ上の階層に移動
alias la="ls -a"
alias vi='vim'

mkgo(){
	mkdir $1 && cd $_
}

chpwd() {
    ls_abbrev
}
# If exist many files and directories
ls_abbrev() {
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

# カレントディレクトリのパスをクリップボードにコピー
alias path='echo -n `pwd` | pbcopy'
# }}}

#{{{ nvm settings
NVM_DIR="$HOME/.nvm"
# load nvm
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
fi
#}}}

#{{{ test alias
alias ubuntu='/usr/bin/osascript -e "tell application \"Terminal\" to set current settings of first window to settings set \"Ubuntu_Dark\""'
alias osx='/usr/bin/osascript -e "tell application \"Terminal\" to set current settings of first window to settings set \"OSX_Dark\""'
#}}}
