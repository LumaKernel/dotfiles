
let b:ale_fixers = ['prettier', 'eslint']

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

setlocal foldmethod=indent
setlocal foldnestmax=2
setlocal foldlevel=1


nnoremap <buffer> <SPACE>so :<C-u>OrganizeImports<CR>
nnoremap <buffer> <SPACE>sf :<C-u>LspDocumentFormatSync<CR>
nnoremap <buffer><expr> <SPACE>si exists(":TypeScriptImport") ? ":<C-u>TypeScriptImport<CR>" : "echo 'No :TypeScriptImport'"
