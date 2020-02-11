set bufhidden=
set buftype=

function s:qfedit() abort
  let tnr0 = tabpagenr()
  let bnr0 = bufnr()
  let wid0 = win_getid()
  let curpos = getcurpos()
  call remove(curpos, 0)
  tabnew
  execute printf('%dbuffer', bnr0)
  bwipeout#
  set buftype=quickfix
  call cursor(curpos)
  exe "normal! \<CR>"
  let bnr1 = bufnr()
  if bnr0 != bnr1
    tabclose
    execute printf('%dtabnext', tnr0)
    execute printf('%dwincmd w', win_id2tabwin(wid0)[1])
    set buftype=
    execute printf('%dbuffer', bnr1)
  else
    tabclose
    execute printf('%dtabnext', tnr0)
    execute printf('%dwincmd w', win_id2tabwin(wid0)[1])
    set buftype=
  endif
endfunction

nnoremap <buffer><silent> <CR> :<C-u>call <SID>qfedit()<CR>

