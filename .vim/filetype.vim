augroup filetypedetect
  au!
  " set filetype
  au BufRead,BufNewFile *.blade.php                         set ft=blade
  au BufRead,BufNewFile *.php                               set ft=php
  au BufRead,BufNewFile *.rb                                set ft=ruby
  au BufRead,BufNewFile *.vim                               set ft=vim
  au BufRead,BufNewFile *.go                                set ft=go
  au BufRead,BufNewFile *.js                                set ft=javascript
  au BufRead,BufNewFile *.ts                                set ft=typescript
  au BufRead,BufNewFile *.vue                               set ft=vue
  au BufRead,BufNewFile *.njk                               set ft=jinja.html
  au BufRead,BufNewFile *.scss                              set ft=scss
  au BufRead,BufNewFile *.sh,*.bash                         set ft=sh
  au BufRead,BufNewFile *.zsh,.zshrc,.zshenv                set ft=zsh
  au BufRead,BufNewFile *.html                              set ft=html
  au BufRead,BufNewFile *.py                                set ft=python
  au BufRead,BufNewFile *.sql                               set ft=sql
  au BufRead,BufNewFile autohotkey.ini,*.ahk                set ft=ahk
  au BufRead,BufNewFile */nginx/*/*.conf                    set ft=conf.nginx
  au BufRead,BufNewFile */httpd/*/*.conf,*/apache2/*/*.conf set ft=conf.apache
  au BufRead,BufNewFile .tmux.conf,*.tmux                   set ft=tmux
  au BufRead,BufNewFile *.yml,*.yaml                        set ft=yaml

  " load template
  " au BufNewFile $HOME/dotfiles/cheat/*/* 0r $HOME/.vim/template/cheat
augroup END

au FileType gitcommit set tw=80
