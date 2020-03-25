
" -- ALE

let b:ale_fixers = ['prettier', 'eslint']

command! -buffer OrganizeImports :LspCodeAction source.organizeImports
nnoremap <Space>so :<C-u>OrganizeImports<CR>
nnoremap <expr> <Space>si exists(":TsuImport") ? ":<C-u>TsuImport<CR>" : "echo 'No :TsuImport'"

