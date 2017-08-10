" highlighting word enclose asterisk
" Allow highlighting word inside comments
highlight Emphasize ctermfg=red ctermbg=black
syntax region Emphasize start=+*+ end=+*+ containedin=vimLineComment oneline
