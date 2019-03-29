"{{{1 signs
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_signs_error = {'text': '☒'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': '>'}
" }}}

" {{{1 debug
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
" for asyncomplete.vim log
let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')
" }}}

" {{{1 language server configurations

" {{{2 bash
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'bash-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
    \ 'whitelist': ['sh'],
    \ })
endif
" }}}

" {{{2 css
if executable('css-languageserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'css-languageserver',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver', '--stdio']},
    \ 'whitelist': ['css', 'sass', 'scss', 'less'],
    \ })
endif
" }}}

" {{{2 docker
if executable('docker-langserver')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'docker-langserver',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
    \ 'whitelist': ['dockerfile'],
    \ })
endif
" }}}

" {{{2 go
if executable('go-langserver')
  augroup LspGo
    au!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'go-langserver',
      \ 'cmd': {server_info->['go-langserver', '-gocodecompletion', '-lint-tool', 'golint']},
      \ 'whitelist': ['go'],
      \ })
    au FileType go call MappingLsp()
  augroup end
endif
" }}}

" {{{2 javascript
if executable('typescript-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'javascript support using typescript-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server', '--stdio']},
    \ 'whitelist': ['javascript', 'javascript.jsx'],
    \ })
endif
"" }}}

" {{{2 PHP
if executable('php-language-server')
  augroup LspPhp
    au!
    au User lsp_setup call lsp#register_server({
      \ 'name': 'php-language-server',
      \ 'cmd': {server_info->['php', 'php-language-server']},
      \ 'whitelist': ['php'],
      \ })
  augroup end
endif
" }}}

" {{{2 yaml
if executable('yaml-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'yaml-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'yaml-language-server --stdio']},
    \ 'whitelist': ['yaml'],
    \ })
endif
" }}}

" }}}

function! MappingLsp()
  nnoremap <buffer><silent> gd :<C-u>LspDefinition<CR>
  nnoremap <buffer><silent> gR :<C-u>LspReferences<CR>
  nnoremap <buffer><silent> gs :<C-u>LspDocumentSymbol<CR>
  nnoremap <buffer><silent> gw :<C-u>LspWorkspaceSymbol<CR>
  nnoremap <buffer><silent> gq :<C-u>LspDocumentFormat<CR>
  nnoremap <buffer><silent> gq :LspDocumentRangeFormat<CR>
  nnoremap <buffer><silent> gi :<C-u>LspImplementation<CR>
  nnoremap <buffer><silent> gr :<C-u>LspRename<CR>
endfunction
