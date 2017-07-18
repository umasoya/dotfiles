# ${vcs_info_msg_0_} : normal message
# ${vcs_info_msg_1_} : warning message
# ${vcs_info_msg_2_} : error message

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:git:*' formats "%F{green}[%b]%c%u%f"
zstyle ':vcs_info:git:*' actionformats '[%b | %a]'
precmd(){ vcs_info }

RPROMPT="${vcs_info_msg_0_}$p_color return:[%?] %{${reset_color}%}"

# Change the color according to the return value of the previous command.
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"
local p_color_bold="%(?.%{${fg_bold[cyan]}%}.%{${fg_bold[magenta]}%})"

PROMPT="
%{$fg[cyan]%}%n@%m
 [%~]%{${reset_color}%} \
${p_color_bold}> %{${reset_color}%}"

# {{{ Suggest prompt
# Suggest like a google.
SPROMPT=" %{$fg[red]%}Did you mean: \
%{${reset_color}%}%{$fg[blue]%}%r%{${reset_color}%}%{$fg[red]%}?%{${reset_color}%} \
[(y)es,(n)o,(a)bort,(e)dit] > "
# }}}
