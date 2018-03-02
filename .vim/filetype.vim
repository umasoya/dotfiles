augroup filetypedetect
  au BufRead,BufNewFile *.php setfiletype php
  au BufRead,BufNewFile *.rb setfiletype ruby
  au BufRead,BufNewFile *.vim setfiletype vim
  au BufRead,BufNewFile *.js setfiletype javascript
  au BufRead,BufNewFile *.go setfiletype go
  au BufRead,BufNewFile *.sh,*.zsh,.zplugrc,.zshrc setfiletype zsh
  au BufRead,BufNewFile *.html setfiletype html
  au BufRead,BufNewFile *.py setfiletype python
  au BufRead,BufNewFile autohotkey.ini,*.ahk setfiletype ahk
augroup END

au FileType gitcommit set tw=80
