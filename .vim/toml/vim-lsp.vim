" signs
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

let g:lsp_signs_error = {'text': '☒'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_hint = {'text': '>'}

" {{{1 debug
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')
" for asyncomplete.vim log
let g:asyncomplete_log_file = expand('/tmp/asyncomplete.log')
" }}}


" bash
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'bash-language-server',
    \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
    \ 'whitelist': ['sh'],
    \ })
endif

" docker
if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif

" go
if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'go-langserver',
        \ 'cmd': {server_info->['go-langserver', '-gocodecompletion', '-lint-tool', 'golint']},
        \ 'whitelist': ['go'],
        \ })
endif


" PHP
if executable('php-language-server')
    au User lsp_setup call lsp#register_server({
         \ 'name': 'php-language-server',
         \ 'cmd': {server_info->['php', 'php-language-server']},
         \ 'whitelist': ['php'],
         \ })
endif
if executable('intelephense')
    au User lsp_setup call lsp#register_server({
         \ 'name': 'intelephense',
         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'intelephense', '--stdio']},
         \ 'whitelist': ['php'],
         \ })
endif

" yaml
if executable('yaml-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'yaml-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'yaml-language-server --stdio']},
        \ 'whitelist': ['yaml'],
        \ })
endif
