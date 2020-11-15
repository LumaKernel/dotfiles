
let b:ale_fixers = ['prettier', 'eslint']
let b:mode = "lsp"

if b:mode is# "lsp"
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
elseif b:mode is# "tsuquyomi"
  nnoremap <buffer> gd :<C-u>TsuDefinition<CR>
  nnoremap <buffer> gt :<C-u>TsuTypeDefinition<CR>
  nnoremap <buffer> gr :<C-u>TsuRenameSymbol<CR>
  nnoremap <buffer> <SPACE>ll :<C-u>TsuGeterrProject<CR>
  nnoremap <buffer> K :<C-u>echo tsuquyomi#hint()<CR>
endif

setlocal foldmethod=indent
setlocal foldnestmax=2
setlocal foldlevel=1
setlocal tabstop=2
setlocal shiftwidth=2
