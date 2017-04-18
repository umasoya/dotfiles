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
augroup END
" }}}

" {{{1 General settings

" Vim mode
set nocompatible
set notimeout
set ttimeout
set timeoutlen=100

" Backup
if !isdirectory("~/.vim/tmp")
  call mkdir("~/.vim/tmp","p")
endif
set backupdir=~/.vim/tmp

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

set backspace=indent,eol,start

"======================="
" Fold setting
"======================="

set foldmethod=marker
"set foldtext=MyFoldText()
function MyFoldText()
  let line = getline(v:foldstart)
  let foldlinecount = v:foldend - v:foldstart
endfunction

" Set Tab and EOL chars
set list
set listchars=eol:<,tab:>.

"======================="
" Indent setting
"======================="
" enable filetype plugin indent
filetype plugin indent on

"{{{2 Indent settings
set expandtab
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
set cindent
" }}}

" Completion settings
set wildmenu wildmode=list:full

set nohlsearch
set cursorline
set cursorcolumn

" Enable Filetype
filetype on

" Restore cursor position
"
"augroup vimrcEx
au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
      \ exe "normal g`\"" | endif
    augroup END 

    " In good time scroll
    set scrolloff=5

    " Disable beep
    set visualbell t_vb=
    set noerrorbells

    " }}}

    "{{{ Mapping
    "Press <return> in normal mode, insert a new line
    noremap <CR> o<ESC>
    " Press <Space> in normal mode, insert space
    noremap <space> i<space><ESC>l
    " Press <Control + e> , NERDTreeToggle
    nnoremap <silent><C-e> :NERDTreeToggle<CR>
    "}}}

    "{{{ dein settings
    if &compatible
      set nocompatible
    endif
    set runtimepath+=~/.vim/dein.vim

    call dein#begin(expand('~/.vim/dein.vim'))

    call dein#add('Shougo/dein.vim')
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('thinca/vim-splash')
    call dein#add('mattn/emmet-vim')
    call dein#add('thinca/vim-quickrun')
    call dein#add('fatih/vim-go')
    call dein#add('flyinshadow/php_localvarcheck.vim')
    call dein#add('evanmiller/nginx-vim-syntax')
    call dein#add('jelera/vim-javascript-syntax',{'autoload':{'filetypes':['javascript']}})
    call dein#add('scrooloose/nerdtree')
    call dein#add('digitaltoad/vim-pug')
    call dein#add('nathanaelkane/vim-indent-guides')
    call dein#add('moll/vim-node')

    call dein#end()

    filetype plugin indent on
    syntax enable 

    " If you want to install not installed plugins on startup.
    "if dein#check_install()
    "   call dein#install()
    "endif

    "}}}

    "{{{1 Plugin settings

    " {{{2 Quickrun
    " Quickrun result display in split pane
    let g:quickrun_config={'*': {'split': ''}}
    " Nice and split
    set splitright
    set splitbelow
    " }}}

    " vim-splash setting
    let g:splash#path = expand("~/.dotfiles/.vim" . '/splash.txt')

    "{{{2 php_localvarcheck
    let g:php_localvarcheck_enable = 1
    let g:php_localvarcheck_global = 0
    " }}}

    "{{{2 vim-indent-guide
    " autorun vim-indent-guide
    let g:indent_guides_enable_on_vim_startup = 1
    " disable auto-colors
    let g:indent_guides_auto_colors=0
    " set guide size
    let g:indent_guides_guide_size = 2
    " set bg color Odd
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=8
    " set bg color Even
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=16
    " set guide start revel
     let g:indent_guides_start_level = 2
     " }}}

     "{{{2 emmet-vim
     " key-bind <Ctrl + y> + ,
     let g:user_emmet_leader_key='<C-y>'
     let g:user_emmet_settings = {
           \ 'variables' : {
           \'lang' : 'ja'
           \}
           \}
     " }}}
     "
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
