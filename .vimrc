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
	autocmd InsertEnter * highlight CursorLine ctermbg=none | highlight CursorColumn ctermbg=none 
	autocmd InsertLeave * highlight CursorLine ctermbg=233 | highlight CursorColumn ctermbg=233 
augroup END
" }}}

" {{{ General settings

" Vim mode
set nocompatible
set notimeout
set ttimeout
set timeoutlen=100

" UTF-8
set encoding=utf-8

" Display line
set number

" Display ruler
set ruler
set rulerformat=[L:%l/%L\ C:%v]

" Linking the clipboard and unnamed register
set clipboard=unnamed

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

" Disable soft tab
set noexpandtab

"======================="
" Indent setting
"======================="
" Indent settings
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
" Like C lang
set cindent

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

" {{{ Plugin settings

" Quickrun result display in split pane
let g:quickrun_config={'*': {'split': ''}}
" Nice and split
set splitright
set splitbelow

" vim-splash setting
let g:splash#path = expand("~/.dotfiles/.vim" . '/splash.txt')

"  }}}

"{{{ Mapping
"Press <return> in normal mode, insert a new line
noremap <CR> o<ESC>
" Press <Space> in normal mode, insert space
noremap <space> i<space><ESC>l
"}}}

"{{{ bundle settings
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'

"コメントON/OFFを手軽に実行
"NeoBundle 'tomtom/tcomment_vim'

" Message is display on startup
NeoBundle 'thinca/vim-splash'

" Emmet
NeoBundle 'mattn/emmet-vim'

" quickrun
NeoBundle 'thinca/vim-quickrun'
let g:quickrun_config = {'*': {'hook/time/enable': '1'}, }

" Golang
NeoBundle 'fatih/vim-go'

" Solarized
NeoBundle 'altercation/vim-colors-solarized'

" Nginx syntax highlight
NeoBundle 'evanmiller/nginx-vim-syntax'

" javascript-syntax
NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}

call neobundle#end()

" Check plugin
NeoBundleCheck

filetype plugin indent on

" Colorscheme settings
syntax enable 
colorscheme solarized
set background=dark
let g:solarized_termcolors=256
" }}}

" {{{ neocomplcache
let g:neocomplcache_enable_at_startup = 1
" }}}

