" highlighting word enclose asterisk
" Allow highlighting word inside comments
highlight Emphasize ctermfg=203 ctermbg=black
syntax region Emphasize start=+*+ end=+*+ containedin=zshComment oneline
