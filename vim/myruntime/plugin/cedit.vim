function! s:cedit() abort
  let tnr = tabpagenr()
  tabnew
  copen
  let bnr = bufnr()
  close
  bwipeout
  execute printf('%dtabnext', tnr)
  execute printf('%dbuffer', bnr)
  let b:opened_from_cedit = 1
endfunction

command! Cedit call <SID>cedit()
