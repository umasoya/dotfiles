" Yasuto's vimrc
"        _                    
" _   __(_)___ ___  __________
"| | / / / __ `__ \/ ___/ ___/
"| |/ / / / / / / / /  / /__  
"|___/_/_/ /_/ /_/_/   \___/  
"                             

" {{{ 基本設定 

" Vim mode
set nocompatible
set notimeout
set ttimeout
set timeoutlen=100

" 文字コードをUTF-8
set encoding=utf-8

"行数表示
set number

" vimの無名レジスタとクリップボードを連携
set clipboard=unnamed

" 折りたたみ有効化
set foldmethod=marker

" tab文字と行末文字の設定
set list
set listchars=eol:<,tab:>.

"ソフトタブ無効
set noexpandtab

"インデント時にインデントする文字数
set autoindent
set smartindent
set shiftwidth=2
set tabstop=2
" C言語スタイルのインデント
set cindent

"補完
set wildmenu wildmode=list:full

set nohlsearch
set cursorline

" ファイルタイプによるスニペットを有効化
filetype on

" カーソル位置の記憶
augroup vimrcEx
	  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
		  \ exe "normal g`\"" | endif
	augroup END 

" 余裕を持ってスクロールする
set scrolloff=5

" ビープ音無効
set visualbell t_vb=
set noerrorbells

" }}}

"" {{{ 拡張設定
"
"" Switch Incert Mode
" これonにすると矢印キーでバグる
"if executable('osascript')
"	let s:keycode_jis_eisuu = 102
"	let g:force_alphanumeric_input_command = "osascript -e 'tell application \"System Events\" to key code " . s:keycode_jis_eisuu . "' &"
"
"	inoremap <silent> <Esc> <Esc>:call system(g:force_alphanumeric_input_command)<CR>
"
"	autocmd! FocusGained *
"				\ call system(g:force_alphanumeric_input_command)
"endif
"
""  }}}

" {{{ プラグインの設定

" quickrunの出力をスプリットで開く
let g:quickrun_config={'*': {'split': ''}}
" 縦分割時は右に,横分割時は下に新しいウィンドウを開く
set splitright
set splitbelow

" vim-splashの設定
let g:splash#path = expand("~/.dotfiles/.vim" . '/splash.txt')

"  }}}

" マッピング {{{

"ノーマルモード時にエンターキーで改行挿入
noremap <CR> o<ESC>

" ノーマルモード時にスペースキーで半角スペース挿入
noremap <space> i<space><ESC>l

" }}}

"{{{ bundle関連
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'

" これ on にしたら wq の返り値が1になる!!
"NeoBundle 'Shougo/neosnippet'
"NeoBundle 'Shougo/neosnippet-snippets'

" smartinputを有効
" これも上記同様怪しい
"NeoBundle 'kana/vim-smartinput'
"NeoBundle 'cohama/vim-smartinput-endwise'
""call smartinput_endwise#define_default_rules()


"コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'

" 起動時にAAやらメッセージ表示
NeoBundle 'thinca/vim-splash'

" クイックラン
NeoBundle 'thinca/vim-quickrun'
let g:quickrun_config = {'*': {'hook/time/enable': '1'}, }

" Solarized
NeoBundle 'altercation/vim-colors-solarized'

call neobundle#end()

"未インストールのプラグインがある場合、インストールするか確認
NeoBundleCheck

filetype plugin indent on

syntax enable on
colorscheme solarized


" }}}

" {{{neocomplcache
let g:neocomplcache_enable_at_startup = 1

" Enable omni completion. Not required if they are already set elsewhere in.vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" }}}

"commit
