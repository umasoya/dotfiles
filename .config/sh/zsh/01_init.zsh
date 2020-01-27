# {{{1 Check system
case "${OSTYPE}" in
    *darwin*)
        export IS_MAC=1
        ;;
    *linux*)
        export IS_LINUX=1
        export DIST=`cat /etc/os-release | awk -F'["]' 'NR==1{print $2}' | awk '{print $1}'` 2>/dev/null
        ;;
esac
# }}}

bindkey -v

# {{{1 options
# auto cd
setopt auto_cd

# beep
setopt no_beep
setopt no_list_beep
setopt no_hist_beep

# hist
setopt auto_pushd
setopt pushd_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space

# suggest spelling similar
# setopt correct_all

# completion use glob
setopt extended_glob

# expand brace
setopt brace_ccl

# word split as bash
setopt sh_word_split

# notify when background job finished
setopt notify

# deploy valiables in prompt
setopt prompt_subst

# Consider # and later as comment
setopt interactive_comments
# }}}
