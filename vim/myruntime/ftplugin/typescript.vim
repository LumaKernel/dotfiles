
let b:ale_fixers = ['prettier', 'eslint']

setlocal foldmethod=indent
setlocal foldnestmax=5
setlocal foldlevel=1
setlocal tabstop=2
setlocal shiftwidth=2

command! -buffer -bar DenoCache !deno cache %
