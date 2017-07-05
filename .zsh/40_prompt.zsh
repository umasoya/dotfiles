# auto reload prompt
promptinit

# Change the color according to the return value of the previous command.
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"

# Set screen_no if it exists.
local window_no="${WINDOW:+"[$WINDOW]"}"

PROMPT="
%{$fg[cyan]%}%n@%m%{${reset_color}%} $github_status
$p_color [%~] > %{${reset_color}%}"

# {{{ Suggest prompt
# Suggest like a google.
SPROMPT=`\cat << EOS
( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
=> 
EOS
`
# }}}

# {{{2 vcs_info
checkGitUser(){
  local insideProject=`git rev-parse --is-inside-work-tree 2>/dev/null`
  if [ ${insideProject} ];then
    gitUser=`git config user.name 2>/dev/null`
  else
    gitUser=''
  fi
}
add-zsh-hook chpwd checkGitUser

# ${vcs_info_msg_0_} : normal message
# ${vcs_info_msg_1_} : warning message
# ${vcs_info_msg_2_} : error message

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:git:*' formats "%F{green}[%b]%c%u%f"
zstyle ':vcs_info:git:*' actionformats '[%b | %a]'

precmd(){ vcs_info }
# }}}

RPROMPT='${gitUser} ${vcs_info_msg_0_}'"$p_color return:[%?] %{${reset_color}%} "
