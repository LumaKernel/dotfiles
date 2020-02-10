finish
set bufhidden=
set buftype=

function s:qfedit() abort
  set buftype=quickfix
  exe "normal! \<C-CR>"
  let nr = bufnr()
  close
  set buftype=
  exe 'buffer' nr
endfunction

nnoremap <buffer><silent> <CR> :<C-u>call <SID>qfedit()<CR>

