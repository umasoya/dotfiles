if &compatible
  set nocompatible
endif

" auto install
let s:dein_dir = $HOME . '/.vim/dein.vim'
if !isdirectory(s:dein_dir)
  call system('git clone https://github.com/Shougo/dein.vim.git ' . shellescape(s:dein_dir))
endif

set runtimepath+=~/.vim/dein.vim

if dein#load_state(s:dein_dir)

  let g:dein#cache_directory = $HOME . '/.cache/dein'

  call dein#begin(s:dein_dir)

  let s:toml_dir  = $HOME . '/.vim/toml'

  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lsp_toml  = s:toml_dir . '/dein_lsp.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'

  " eager loading
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lsp_toml,  {'lazy': 0})
  " lazy loading
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
   call dein#install()
endif
