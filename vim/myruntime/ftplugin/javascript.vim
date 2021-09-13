
" -- ALE

let b:ale_fixers = ['prettier']

command! -buffer OrganizeImports :LspCodeAction source.organizeImports
command! -range -nargs=0 TypeScriptImport call lsp#ui#vim#code_action#do({
    \   'sync': v:false,
    \   'selection': <range> != 0,
    \   'query_filter': { action -> get(action, 'title', '') =~#
    \     '^Import ''\k\+'' from module "\f\+"\|' ..
    \     '^Add ''\k\+'' to existing import declaration from "\f\+"'
    \   }
    \ })

setlocal foldmethod=indent
setlocal foldnestmax=2
setlocal foldlevel=2
setlocal foldlevelstart=2
setlocal foldminlines=2
setlocal tabstop=2
setlocal shiftwidth=2

function! MyTsFormat()
  let save_cursor = getcurpos()
  %!prettier --loglevel silent --stdin-filepath %
  if v:shell_error
    undo
    call setpos('.', save_cursor)
    return
  endif
  %!eslint_d --stdin --stdin-filename % --fix-to-stdout
  if v:shell_error
    undo
    call setpos('.', save_cursor)
    return
  endif
  call setpos('.', save_cursor)
endfunction

function! MyTsFormatEslintd()
  let save_cursor = getcurpos()
  %!eslint_d --stdin --stdin-filename % --fix-to-stdout
  if v:shell_error
    undo
    call setpos('.', save_cursor)
    return
  endif
  call setpos('.', save_cursor)
endfunction

if executable('prettier') && executable('eslint_d')
  nnoremap <leader>ss :silent! call MyTsFormat()<CR>
  nnoremap <leader>se :silent! call MyTsFormatEslintd()<CR>
endif
