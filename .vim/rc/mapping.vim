"Press <return> in normal mode, insert a new line
noremap <CR> o<ESC>

" Press <Space> in normal mode, insert space
noremap <space> i<space><ESC>l

" Press <Ctrl + [h,j,k,l]>, move max
nnoremap <C-h> ^
nnoremap <C-j> G
nnoremap <C-k> gg
nnoremap <C-l> $

"{{{1 Pain
" split
nnoremap T- :split<CR>
nnoremap T\ :vsplit<CR>

" move pain
nnoremap Th <C-w>h
nnoremap Tj <C-w>j
nnoremap Tk <C-w>k
nnoremap Tl <C-w>l

" replace pain
nnoremap TH <C-w>H
nnoremap TJ <C-w>J
nnoremap TK <C-w>K
nnoremap TL <C-w>L
" position rotate
nnoremap TR <C-w>r
"}}}

" Do not leave visual mode after increment/derement.
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv
