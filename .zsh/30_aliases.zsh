#{{{ suffix aliases
alias -s tar.gz='tar zxvf'
#}}}

if [[ $DISTRIBUTION == "osx" ]]; then
        alias ls="gls -F --color=auto"
else
        alias ls="ls --color=auto"
fi

alias la='ls -a'
# alias lla='\ls -al'
alias vi='vim'
alias vw='view'
alias reshell='exec ${SHELL} -l'
alias rc='source ${HOME}/.zshrc'
alias cd=gitcd

mkgo(){
	mkdir $1 && cd $_
}

chpwd() {
    ls_abbrev
}
# {{{ ls_abbrev
# If exist many files and directories
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-CF' '--color=always')
    #opt_ls=('-aCF' '--color=always')
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
# }}}

# get current path
alias path='echo -n `pwd` | pbcopy'

# {{{ gitcd -- cd_wrapper
# If current directory is inside 'git project', `cd /` is goto 'Project Root'
# *@todo completion*
gitcd(){
  # If argument is not '/' or '/path/to', regular `cd`
  if [[ ! "${1}" =~ "^/.*" || "${1}" =~ "^${HOME}.*" ]]; then
    builtin cd "${@}"
    return
  fi

  #If current dir is not inside project, regular `cd`
  local insideProject=`git rev-parse --is-inside-work-tree 2>/dev/null`
  if [ ! "${insideProject}" = "true" ]; then
    builtin cd "${@}"
    return
  fi

  # If current dir is projectRoot, `cd /` is regular action
  local currentDir=`pwd 2>/dev/null`
  local projectRoot=`git rev-parse --show-toplevel 2>/dev/null`

  if [ "${currentDir}" = "${projectRoot}" -a "${1}" = "/" ]; then
    builtin cd "/"
    return
  fi

  # If don't exist ${projectRoot}/path/to, move to /path/to.
  if [ -d "${projectRoot}${1}" ]; then
    builtin cd "${projectRoot}${1}"
  else
    builtin cd "${@}"
  fi
  return
}
# }}}

#{{{ cat always show line number
# catn(){
#   \cat -n "$@"
# }
# alias cat="catn"
# }}}
