augroup filetypedetect
  au BufRead,BufNewFile *.php setfiletype php
  au BufRead,BufNewFile *.rb setfiletype ruby
  au BufRead,BufNewFile *.vim setfiletype vim
  au BufRead,BufNewFile *.js setfiletype javascript
  au BufRead,BufNewFile *.go setfiletype go
  au BufRead,BufNewFile *.sh,*.zsh,.zplugrc,.zshrc setfiletype zsh
  au BufRead,BufNewFile *.html setfiletype html
  au BufRead,BufNewFile nginx.conf setfiletype nginx
augroup END
