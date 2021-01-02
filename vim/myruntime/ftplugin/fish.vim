" Set up :make to use fish for syntax checking.
compiler fish

let b:ale_fixers = []
let b:ale_linters = []

" Enable folding of block structures in fish.
setlocal foldmethod=expr
