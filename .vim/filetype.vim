augroup filetypedetect
  au BufRead,BufNewFile *.php setfiletype php
  au BufRead,BufNewFile *.blade.php setfiletype blade
  au BufRead,BufNewFile *.rb setfiletype ruby
  au BufRead,BufNewFile *.vim setfiletype vim
  au BufRead,BufNewFile *.js setfiletype javascript
  au BufRead,BufNewFile *.zsh,.zshrc,.zshenv setfiletype zsh
  au BufRead,BufNewFile *.html setfiletype html
  au BufRead,BufNewFile *.py setfiletype python
  au BufRead,BufNewFile autohotkey.ini,*.ahk setfiletype ahk
  au BufRead,BufNewFile */nginx/*/*.conf setfiletype nginx
  au BufRead,BufNewFile */httpd/*/*.conf,*/apache2/*/*.conf setfiletype apache
  au BufRead,BufNewFile .tmux.conf setfiletype tmux
augroup END

au FileType gitcommit set tw=80
