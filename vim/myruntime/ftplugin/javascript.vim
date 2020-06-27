
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
