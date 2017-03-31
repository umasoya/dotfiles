augroup filetypedetect
	au BufRead,BufNewFile *.php setfiletype php
	au BufRead,BufNewFile *.rb setfiletype ruby
	au BufRead,BufNewFile *.vim setfiletype vim
augroup END
