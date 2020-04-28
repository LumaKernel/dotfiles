function! SwitchIsKeyword() abort
  if exists("b:isk_save")
    let &isk = b:isk_save
    unlet b:isk_save
  else
    let b:isk_save = &isk
    if '-' =~# '\k'
      setlocal isk=-
    else
      setlocal isk+=-
    endif
  endif
  if '-' =~# '\k'
    echo '"-" is now keyword.'
  else
    echo '"-" is now not keyword.'
  endif
endfunction

command! SwitchIsKeyword call SwitchIsKeyword()
nnoremap <silent> <Plug>(switch-is-keyword) :<C-u>call SwitchIsKeyword()<CR>

" -- my setting

nmap <silent> - <Plug>(switch-is-keyword)
