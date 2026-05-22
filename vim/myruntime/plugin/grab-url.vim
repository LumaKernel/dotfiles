function! s:grab_url_normal() abort
  let url = expand('<cfile>')
  call setreg('+', url)
  echomsg 'Copied: ' . url
endfunction

function! s:grab_url_visual() abort
  let save = @"
  normal! gvy
  let url = @"
  let @" = save
  call setreg('+', url)
  echomsg 'Copied: ' . url
endfunction

nnoremap <silent> gx :<C-u>call <SID>grab_url_normal()<CR>
xnoremap <silent> gx :<C-u>call <SID>grab_url_visual()<CR>
