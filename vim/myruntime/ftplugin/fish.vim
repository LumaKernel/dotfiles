" Set up :make to use fish for syntax checking.
compiler fish

let b:ale_fixers = []
let b:ale_linters = []

" Set this to have long lines wrap inside comments.
setlocal textwidth=79

" Enable folding of block structures in fish.
setlocal foldmethod=expr
