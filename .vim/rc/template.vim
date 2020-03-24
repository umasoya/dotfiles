augroup load_templates
  au!
  au BufNewFile $HOME/dotfiles/cheat/{*,*/*} 0r $HOME/.vim/template/cheat
  au BufNewFile *.go 0r $HOME/.vim/template/go
augroup END
