
function! s:grep_bufname() abort
  execute "FzfPreviewProjectGrepRaw" expand('%:t')
endfunction

command! -bar GrepBufname call s:grep_bufname()


" -- user setting

nnoremap ,jj :<C-u>GrepBufname<CR>
