" Yasuto's vimrc
"        _                    
" _   __(_)___ ___  __________
"| | / / / __ `__ \/ ___/ ___/
"| |/ / / / / / / / /  / /__  
"|___/_/_/ /_/ /_/_/   \___/  
"                             
" {{{ Background transparent
if !has('gui_running')
  augroup trans
    autocmd!
    autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
    autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
    autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
    autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
    autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none
    autocmd VimEnter,ColorScheme * highlight SpecialKey ctermbg=none
    autocmd VimEnter,ColorScheme * highlight CursorLine ctermbg=233
    autocmd VimEnter,ColorScheme * highlight CursorColumn ctermbg=233
    autocmd VimEnter,ColorScheme * highlight Folded ctermbg=none
    autocmd VimEnter,ColorScheme * highlight Visual ctermfg=20 ctermbg=255
  augroup END
endif

" Change cursorline color when entering insert mode
augroup vimrc_change_cursorline_color
  autocmd!
  "autocmd InsertEnter * highlight CursorLine ctermbg=none | highlight CursorColumn ctermbg=none
  autocmd InsertEnter * highlight CursorLine ctermbg=233 | highlight CursorColumn ctermbg=233
  autocmd InsertLeave * highlight CursorLine ctermbg=233 | highlight CursorColumn ctermbg=233
  autocmd InsertEnter * highlight StatusLine ctermbg=172
  autocmd InsertLeave * highlight StatusLine ctermbg=248
augroup END
" }}}

" {{{1 General settings

" Vim mode
set nocompatible
set notimeout
set ttimeout
set timeoutlen=100

" Backup
if !isdirectory($HOME . '/.vim/tmp')
  call mkdir($HOME . '/.vim/tmp',"p")
endif
set backupdir=$HOME/.vim/tmp

" Undo
if !isdirectory($HOME . '/.vim/undo')
  call mkdir($HOME . '/.vim/undo', "p")
endif
set undodir=$HOME/.vim/undo

" Swap
if !isdirectory($HOME . '/.vim/swap')
  call mkdir($HOME . '/.vim/swap', "p")
endif
set directory=$HOME/.vim/swap

" UTF-8
set encoding=utf-8

" Display line
set number

" Display ruler
set ruler
set rulerformat=[L:%l/%L\ C:%v]

" Display Statusline
set laststatus=2

" Linking the clipboard and unnamed register
set clipboard=unnamed

" Enable backspace
set backspace=indent,eol,start

" Set syntax max col
set synmaxcol=400

" Set expandtab
set expandtab

"======================="
" Fold setting
"======================="

set foldmethod=marker
"set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  let foldlinecount = v:foldend - v:foldstart
endfunction

" Set Tab and EOL chars
set list
set listchars=tab:>-

" enable filetype plugin indent
filetype plugin indent on

" Completion settings
set wildmenu wildmode=list:full

set nohlsearch
set cursorline
set cursorcolumn

" Restore cursor position
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

" In good time scroll
set scrolloff=5

" Disable beep
set visualbell t_vb=
set noerrorbells

" Increment/Decrement config
set nrformats=alpha

" load private help
helptags $HOME/.vim/doc/
" }}}

"{{{ Mapping
"Press <return> in normal mode, insert a new line
noremap <CR> o<ESC>

" Press <Space> in normal mode, insert space
noremap <space> i<space><ESC>l

" Press <Ctrl + [h,j,k,l]>, move max
nnoremap <C-h> ^
nnoremap <C-j> G
nnoremap <C-k> gg
nnoremap <C-l> $

" Do not leave visual mode after increment/derement.
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
"}}}

"{{{ dein configs
if &compatible
  set nocompatible
endif

set runtimepath+=~/.vim/dein.vim

if dein#load_state($HOME . '/.vim/dein.vim')

  let g:dein#cache_directory = $HOME . '/.cache/dein'

  call dein#begin(expand('~/.vim/dein.vim'))

  let s:toml_dir  = $HOME . '/.vim/toml'
  let s:toml      = s:toml_dir . '/dein.toml'
  " let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,   {'lazy': 0})
  " call dein#load_toml(s:lazy_toml,   {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
   call dein#install()
endif

"}}}

"{{{1 Colorscheme settings
"{{{2 solarized
"colorscheme solarized
"set background=dark
"let g:solarized_termcolors=256
"}}}
"{{{2 tender
colorscheme tender
"}}}
"}}}
