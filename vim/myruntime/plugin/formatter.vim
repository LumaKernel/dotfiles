
function! s:FormatJSON(line1, line2) abort
  let curpos = getcurpos()
  let winview = winsaveview()

  execute printf("normal! :%d,%d!npx -q prettier --parser json\<CR>", a:line1, a:line2)

  call winrestview(winview)
  call setpos('.', curpos)
endfunction


command! -bar -range FormatJSON call <SID>FormatJSON(<line1>, <line2>)
