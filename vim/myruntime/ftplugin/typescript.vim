
let b:ale_fixers = ['prettier', 'eslint']

if g:ts_lsp_mode is# "lsp" && g:lsp_mode == "vim-lsp"
  command! -buffer -nargs=0 -bar OrganizeImports LspCodeAction source.organizeImports
  command! -buffer -nargs=0 -bar OrganizeImportsSync LspCodeActionSync source.organizeImports
  command! -buffer -nargs=0 -bar TypeScriptFormatSync OrganizeImportsSync | LspDocumentFormatSync
  command! -range -nargs=0 -bar TypeScriptImport call lsp#ui#vim#code_action#do({
      \   'sync': v:false,
      \   'selection': <range> != 0,
      \   'query_filter': { action -> get(action, 'title', '') =~#
      \     '^Import ''\k\+'' from module "@\?\f\+"\|' ..
      \     '^Add ''\k\+'' to existing import declaration from "@\?\f\+"'
      \   }
      \ })
  nnoremap <buffer> <SPACE>so :<C-u>OrganizeImports<CR>
  nnoremap <buffer> <SPACE>sf :<C-u>LspDocumentFormatSync<CR>
  nnoremap <buffer><expr> <SPACE>si exists(":TypeScriptImport") ? ":<C-u>TypeScriptImport<CR>" : "echo 'No :TypeScriptImport'"
elseif g:ts_lsp_mode is# "tsu"
  nnoremap <buffer> gd :<C-u>TsuDefinition<CR>
  nnoremap <buffer> gt :<C-u>TsuTypeDefinition<CR>
  nnoremap <buffer> gr :<C-u>TsuRenameSymbol<CR>
  nnoremap <buffer> <SPACE>ll :<C-u>TsuGeterr<CR>
  nnoremap <buffer> K :<C-u>echo tsuquyomi#hint()<CR>
  nnoremap <buffer> <SPACE>si :<C-u>TsuImport<CR>
endif

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

if executable('eslint_d')
  nnoremap <leader>ss :silent! call MyTsFormatEslintd()<CR>
endif

setlocal foldmethod=indent
setlocal foldnestmax=5
setlocal foldlevel=1
setlocal tabstop=2
setlocal shiftwidth=2

command! -buffer -bar DenoCache !deno cache --unstable %
