" Yasuto's vimrc


" {{{ 基本設定 

" 文字コードをUTF-8
set encoding=utf-8

"行数表示
set number

" vimの無名レジスタとクリップボードを連携
set clipboard=unnamed

"折りたたみ有効化
set foldmethod=marker

"tab文字と行末文字の設定
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

"シンタックスハイライト
colorscheme desert
syntax on
set nohlsearch
set cursorline

" ファイルタイプによるスニペットを有効化
filetype on

" カーソル位置の記憶
augroup vimrcEx
	  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
		  \ exe "normal g`\"" | endif
	augroup END "`""'")

" }}}

" マッピング {{{

"ノーマルモード時にエンターキーで改行挿入
noremap <CR> o<ESC>

" ノーマルモード時にスペースキーで半角スペース挿入
noremap <space> i<space><ESC>l

" }}}

"{{{bundleで管理するディレクトリ指定
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

" smartinputを有効
NeoBundle 'kana/vim-smartinput'
NeoBundle 'cohama/vim-smartinput-endwise'
"call smartinput_endwise#define_default_rules()


"コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'

" 自動括弧閉じ
NeoBundle 'Townk/vim-autoclose'

" 起動時にAAやらメッセージ表示
NeoBundle 'thinca/vim-splash'

call neobundle#end()

filetype plugin indent on

"未インストールのプラグインがある場合、インストールするか確認
NeoBundleCheck

" }}}

" {{{neosnippet

" スニペット用ディレクトリの指定
let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/neosnippets/'

"Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
 
 " SuperTab like snippets behavior.
 imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
 smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: "\<TAB>"
  
  " For snippet_complete marker.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
"}}}

" {{{neocomplcache
let g:neocomplcache_enable_at_startup = 1

" Enable omni completion. Not required if they are already set elsewhere in.vimrc
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" }}}

