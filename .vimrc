" Yasuto's vimrc
"        _                    
" _   __(_)___ ___  __________
"| | / / / __ `__ \/ ___/ ___/
"| |/ / / / / / / / /  / /__  
"|___/_/_/ /_/ /_/_/   \___/  
"                             

let g:vim_home = expand($HOME . "/.vim")
let g:rc_dir = expand($HOME . "/.vim/rc")

function! s:source_rc(target)
  let rc_file = expand(g:rc_dir . '/' . a:target)
  if filereadable(rc_file)
    execute 'source' rc_file
  endif
endfunction

call s:source_rc('init.vim')
call s:source_rc('color.vim')
call s:source_rc('mapping.vim')
call s:source_rc('template.vim')
call s:source_rc('dein.vim')
