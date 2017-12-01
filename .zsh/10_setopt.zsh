# auto cd
setopt auto_cd

# no beep
setopt no_beep
setopt no_list_beep
setopt no_hist_beep

setopt auto_pushd

# pushd ignore add duplicate path
setopt pushd_ignore_dups

# suggest spelling similar command
setopt correct

# sugest spelling similar all
setopt correct_all

# completion use glob
setopt extended_glob

# match dot files
#setopt globdots

# history ignore add duplicate command
setopt hist_ignore_all_dups

# history ignore add strat space
setopt hist_ignore_space

# Expand brace deploy {foo123a-c} -> foo1 foo2 foo3 fooa foob fooc
setopt brace_ccl

# word split as bash
setopt sh_word_split

# When backgroundjob finished, nitification.
setopt notify

# deploy valiables in prompt
setopt prompt_subst

# Consider # and later as comment
setopt interactive_comments
