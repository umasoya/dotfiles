if &compatible
  set nocompatible
endif

set runtimepath+=~/.vim/dein.vim

if dein#load_state($HOME . '/.vim/dein.vim')

  let g:dein#cache_directory = $HOME . '/.cache/dein'

  call dein#begin(expand('~/.vim/dein.vim'))

  let s:toml_dir  = $HOME . '/.vim/toml'
  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
   call dein#install()
endif
