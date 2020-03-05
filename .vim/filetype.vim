augroup filetypedetect
  au!
  " set filetype
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
  au BufRead,BufNewFile *.yml,*.yaml                        setfiletype yaml

  " load template
  " au BufNewFile $HOME/dotfiles/cheat/*/* 0r $HOME/.vim/template/cheat
augroup END

au FileType gitcommit set tw=80
