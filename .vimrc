"{{{bundleで管理するディレクトリ指定
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neosnippet.git'
NeoBundle 'Shougo/neosnippet-snippets'

"コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'

" 自動括弧閉じ
NeoBundle 'Townk/vim-autoclose'

" 起動時にAAやらメッセージ表示
NeoBundle 'thinca/vim-splash'

"未インストールのプラグインがある場合、インストールするか確認
NeoBundleCheck

call neobundle#end()

filetype plugin indent on
" }}}

" {{{neosnippet
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

"行数表示
set number

"ペースト時にずれないように設定
set paste

"折りたたみ有効化
set foldmethod=marker

"tab文字と行末文字の設定
set list
set listchars=eol:<,tab:>.

"ソフトタブ無効
set noexpandtab

"インデント時にインデントする文字数
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent

"補完
set wildmenu wildmode=list:full

"シンタックスハイライト
colorscheme desert
syntax on
set nohlsearch
set cursorline

"ノーマルモード時にエンターキーで改行挿入
noremap <CR> o<ESC>

