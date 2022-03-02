" Runtime path
" -------------------
set runtimepath+=~/.vim

" Backup
" -------------------
if !isdirectory($HOME . '/.vim/tmp')
  call mkdir($HOME . '/.vim/tmp', 'p')
endif
set backupdir=$HOME/.vim/tmp

" Undo
" -------------------
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', 'p')
endif
set undodir=$HOME/.vim/undo

" Swap
" -------------------
if !isdirectory($HOME . '/.vim/swap')
  call mkdir($HOME . '/.vim/swap', 'p')
endif
set directory=$HOME/.vim/swap

" Help
helptags $HOME/.vim/doc/

" Log
" set verbosefile=/tmp/vim.log
" set verbose=20

" system config
" -------------------
set notimeout
set ttimeout
set timeoutlen=100
set visualbell t_vb=
set noerrorbells
set encoding=utf-8
set clipboard=unnamed
set backspace=indent,eol,start
set nrformats=alpha
set modeline
set modelines=5
" Use regexpengine for regexp
" @see https://www.soum.co.jp/misc/vim-advanced/3/
" -------------------
set regexpengine=1

" indent
" -------------------
set autoindent
set smartindent
set cindent
filetype plugin indent on

" Restore cursor position
" -------------------
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

" system visual
" -------------------
set number
set ruler

set laststatus=2

set synmaxcol=400
set wildmenu
set wildignorecase
set wildmode=list:full
set scrolloff=5
set formatoptions=r
if has("nvim")
  set cursorline
  set cursorcolumn
endif

" text visual
" -------------------
set expandtab
set foldmethod=marker
set nohlsearch

" popup color
" -------------------
set pumblend=10
