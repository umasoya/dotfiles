augroup filetypedetect
  au BufRead,BufNewFile *.php                               setfiletype php
  au BufRead,BufNewFile *.blade.php                         if &ft == 'php' | set ft=blade | endif
  au BufRead,BufNewFile *.rb                                setfiletype ruby
  au BufRead,BufNewFile *.vim                               setfiletype vim
  au BufRead,BufNewFile *.js                                setfiletype javascript
  au BufRead,BufNewFile *.ts                                if &ft == 'xml' | set ft=typescript | endif
  au BufRead,BufNewFile *.zsh,.zshrc,.zshenv                setfiletype zsh
  au BufRead,BufNewFile *.html                              setfiletype html
  au BufRead,BufNewFile *.py                                setfiletype python
  au BufRead,BufNewFile autohotkey.ini,*.ahk                setfiletype ahk
  au BufRead,BufNewFile */nginx/*/*.conf                    setfiletype conf.nginx
  au BufRead,BufNewFile */httpd/*/*.conf,*/apache2/*/*.conf setfiletype conf.apache
  au BufRead,BufNewFile .tmux.conf,*.tmux                   setfiletype tmux
  au BufRead,BufNewFile */playbooks/*.yml                   setfiletype yaml.ansible
augroup END

au FileType gitcommit set tw=80
