" highlight multi-byte space
augroup highlightMultiByteSpace
  autocmd!
  autocmd VimEnter,Winenter * match ErrorMsg /　/
augroup END

" set colorscheme
colorscheme tender

if has('mac')
    " {{{1 mac
    " {{{2 Background transparent
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
    " }}}
    " }}}
elseif has('unix')
    " {{{1 unix
    " {{{2 Background transparent
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
    " }}}
    " }}}
else
    " {{{1 windows
    " {{{2 Background transparent
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
    " }}}
    " }}}
endif
