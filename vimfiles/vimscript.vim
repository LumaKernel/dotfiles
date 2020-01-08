
" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")

nnoremap <Leader>; :VimShowHlGroup<CR>
nnoremap <Leader>: :VimShowHlItem<CR>

call add(g:mapping_descriptions, ['<Leader>;', ':VimShowHlGroup'])
call add(g:mapping_descriptions, ['<Leader>:', ':VimShowHlItem'])


" debug

finish

command! MES :new | set buftype=nofile | :put =execute('mes') | :only
command! M :new | set buftype=nofile | :put =g:mymes | :only
command! MC :let g:mymes=[]

