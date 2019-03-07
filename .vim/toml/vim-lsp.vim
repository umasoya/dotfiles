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

" yaml
if executable('yaml-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'yaml-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'yaml-language-server --stdio']},
        \ 'whitelist': ['yaml'],
        \ })
endif
