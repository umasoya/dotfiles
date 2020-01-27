augroup load_templates
  au!
  au BufNewFile $HOME/dotfiles/cheat/{*,*/*} 0r $HOME/.vim/template/cheat
augroup END
