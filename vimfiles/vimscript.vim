
" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")

nnoremap <Leader>; :VimShowHlGroup<CR>
nnoremap <Leader>: :VimShowHlItem<CR>



" debug

finish

command! GO cd ~/.cache/dein/repos/github.com/LumaKernel/coquille/dev/coq-examples
command! MES :new | :put =execute('mes') | :only
command! M :new | :put =g:mymes | :only
command! MC :let g:mymes=[]

