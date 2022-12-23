" highlighting word enclose asterisk
" Allow highlighting word inside comments
" Conceal highlighting tag when normal mode and console mode.
" syntax region Emphasize start=+*+ end=+*+ containedin=zshComment oneline contains=EmphasizeTag keepend
" syntax match EmphasizeTag '*' containedin=Emphasize conceal
highlight Emphasize ctermfg=203 ctermbg=black

syntax match zshTilde '\~'
highlight link zshTilde zshRedir

" zplug
syntax keyword zshCommands zplug
syntax keyword zshKeyword  as use ignore from at rename-to dir if hook-build
                          \ hook-load frozen on defer lazy depth
syntax keyword zshDeref    plugin command theme github bitbucket gh-r gist
                          \ oh-my-zsh prezto local

set conceallevel=3
set concealcursor=nc
