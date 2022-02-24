" highlight multi-byte space
augroup highlightMultiByteSpace
  autocmd!
  autocmd VimEnter,Winenter * match ErrorMsg /　/
augroup END

" set colorscheme
" colorscheme tender
colorscheme solarized

if has('mac')
  set background=dark
else
  set background=light
  if !has('gui_running')
    augroup trans
      autocmd!
      autocmd VimEnter,ColorScheme * highlight Normal ctermbg=none
      autocmd VimEnter,ColorScheme * highlight LineNr ctermbg=none
      autocmd VimEnter,ColorScheme * highlight SignColumn ctermbg=none
      autocmd VimEnter,ColorScheme * highlight VertSplit ctermbg=none
      autocmd VimEnter,ColorScheme * highlight NonText ctermbg=none
      autocmd VimEnter,ColorScheme * highlight SpecialKey ctermbg=none
      autocmd VimEnter,ColorScheme * highlight CursorLine ctermbg=233
      autocmd VimEnter,ColorScheme * highlight CursorColumn ctermbg=233
      autocmd VimEnter,ColorScheme * highlight Folded ctermfg=013 ctermbg=none
      autocmd VimEnter,ColorScheme * highlight Visual ctermfg=20 ctermbg=255
    augroup END
  endif

  " Change cursorline color when entering insert mode
  augroup vimrc_change_cursorline_color
    autocmd!
    autocmd InsertEnter * highlight CursorLine ctermbg=233 | highlight CursorColumn ctermbg=233
    autocmd InsertLeave * highlight CursorLine ctermbg=233 | highlight CursorColumn ctermbg=233
    autocmd InsertEnter * highlight StatusLine ctermbg=172
    autocmd InsertLeave * highlight StatusLine ctermbg=248
  augroup END
endif
