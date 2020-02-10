function! s:cedit() abort
  let tnr = tabpagenr()
  tabnew
  copen
  let bnr = bufnr()
  close
  bwipeout
  execute printf('%dtabnext', tnr)
  execute printf('%dbuffer', bnr)
endfunction

command! Cedit call <SID>cedit()

