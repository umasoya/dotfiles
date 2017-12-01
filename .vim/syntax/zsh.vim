" highlighting word enclose asterisk
" Allow highlighting word inside comments
" Conceal highlighting tag when normal mode and console mode.
syntax region Emphasize start=+*+ end=+*+ containedin=zshComment oneline contains=EmphasizeTag keepend
syntax match EmphasizeTag '*' containedin=Emphasize conceal
highlight Emphasize ctermfg=203 ctermbg=black

set conceallevel=3
set concealcursor=nc
