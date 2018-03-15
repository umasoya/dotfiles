" Backup
if !isdirectory($HOME . '/.vim/tmp')
  call mkdir($HOME . '/.vim/tmp', 'p')
endif
set backupdir=$HOME/.vim/tmp

" Undo
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', 'p')
endif
set undodir=$HOME/.vim/undo

" Swap
if !isdirectory($HOME . '/.vim/swap')
  call mkdir($HOME . '/.vim/swap', 'p')
endif
set directory=$HOME/.vim/swap

" Help
helptags $HOME/.vim/doc/

" system config
set notimeout
set ttimeout
set timeoutlen=100
set visualbell t_vb=
set noerrorbells
set encoding=utf-8
set clipboard=unnamed
set backspace=indent,eol,start
set nrformats=alpha

filetype plugin indent on

" Restore cursor position
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

" system visual
set number
set ruler
set rulerformat=[L:%l/%L\ C:%v]
set laststatus=2
set synmaxcol=400
set wildmenu wildmode=list:full
set scrolloff=5
set formatoptions=r
if has("nvim")
  set cursorline
  set cursorcolumn
endif

" text visual
set expandtab
set foldmethod=marker
set list
set listchars=tab:>-
set nohlsearch
