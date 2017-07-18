# ${vcs_info_msg_0_} : normal message
# ${vcs_info_msg_1_} : warning message
# ${vcs_info_msg_2_} : error message

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:git:*' formats "%F{green}[%b]%c%u%f"
zstyle ':vcs_info:git:*' actionformats '[%b | %a]'


# Change the color according to the return value of the previous command.
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"

# set position display mode
#terminfo_down_left=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
#MODE="-- INSERT --"

PROMPT_TOP=" %{$fg[cyan]%}%n@%m%{${reset_color}%}"
PROMPT="$p_color [%~] > %{${reset_color}%}"

# {{{1 RPROMPT
add-zsh-hook precmd _update_git_status

_update_git_status(){
  LANG=C vcs_info
  if [ -z "${vcs_info_msg_0_}" ];then
    gitUser=''
    RPROMPT_TOP="${gitUser}"
    RPROMPT='${vcs_info_msg_0_}'"$p_color return:[%?] %{${reset_color}%} "
    print -P "\n ${PROMPT_TOP}${(r:($COLUMNS-${#PROMPT_TOP}-${#RPROMPT_TOP}):: :)}$RPROMPT_TOP" 
    return 0
  fi

  checkGitUser

  print -P "\n ${PROMPT_TOP}${(r:($COLUMNS-${#PROMPT_TOP}-${#RPROMPT_TOP}):: :)}$RPROMPT_TOP" 
}

checkGitUser(){
  local insideProject=`git rev-parse --is-inside-work-tree 2>/dev/null`
  if [ ${insideProject} ];then
    gitUser="`git config user.name 2>/dev/null` "
  else
    gitUser=''
  fi

  RPROMPT_TOP="${gitUser}"
  RPROMPT='${vcs_info_msg_0_}'"$p_color return:[%?] %{${reset_color}%} "
}
# }}}

# {{{ Suggest prompt
# Suggest like a google.
SPROMPT=" %{$fg[red]%}Did you mean: \
%{${reset_color}%}%{$fg[blue]%}%r%{${reset_color}%}%{$fg[red]%}?%{${reset_color}%} \
[(y)es,(n)o,(a)bort,(e)dit] > "
# }}}
