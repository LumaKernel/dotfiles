set bufhidden=
set buftype=

function s:qfedit() abort
  let tnr0 = tabpagenr()
  let bnr0 = bufnr()
  let wid0 = win_getid()
  tabnew
  execute printf('%dbuffer', bnr0)
  bwipeout #
  set buftype=quickfix
  exe "normal! \<C-w>\<CR>"
  bwipeout #
  let bnr1 = bufnr()
  tabclose
  execute printf('%dtabnext', tnr0)
  execute printf('%dwincmd w', win_id2tabwin(wid0)[1])
  set buftype=
  execute printf('%dbuffer', bnr1)
endfunction

nnoremap <buffer><silent> <CR> :<C-u>call <SID>qfedit()<CR>

