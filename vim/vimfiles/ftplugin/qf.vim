set bufhidden=
set buftype=

function s:qfedit() abort
  let tnr0 = tabpagenr()
  let bnr0 = bufnr()
  let wid0 = win_getid()
  let curpos0 = getcurpos()
  call remove(curpos0, 0)
  tabnew
  execute printf('%dbuffer', bnr0)
  bwipeout#
  set buftype=quickfix
  call cursor(curpos0)
  exe "normal! \<CR>"
  let bnr1 = bufnr()
  if bnr0 != bnr1
    let curpos1 = getcurpos()
    call remove(curpos1, 0)
    tabclose
    execute printf('%dtabnext', tnr0)
    execute printf('%dwincmd w', win_id2tabwin(wid0)[1])
    set buftype=
    execute printf('%dbuffer', bnr1)
    call cursor(curpos1)
  else
    tabclose
    execute printf('%dtabnext', tnr0)
    execute printf('%dwincmd w', win_id2tabwin(wid0)[1])
    set buftype=
  endif
endfunction

nnoremap <buffer><silent> <CR> :<C-u>call <SID>qfedit()<CR>

