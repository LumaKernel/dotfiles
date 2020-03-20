
function! MoveLine(count) abort
  if a:count == 0 | return | endif
  let l:reg_save = @@

  let l:buflen = len(getbufline('%', 1, '$'))
  let l:is_last = line('.') == l:buflen

  let l:curpos = getcurpos()
  call remove(l:curpos, 0)
  let l:curpos[0] += a:count
  let l:curpos[0] = min([max([l:curpos[0], 1]), l:buflen])

  delete

  if a:count < 0
    let l:move = -a:count - l:is_last
    if l:move > 0
      execute 'normal! ' .. l:move .. "\<Up>"
    endif
    put!
  else
    let l:move = a:count - 1
    if l:move > 0
      execute 'normal! ' .. l:move .. "\<Down>"
    endif
    put
  endif

  call cursor(l:curpos)
  let @@ = l:reg_save
endfunction

function! MoveMultiLines(count) abort
  if a:count == 0 | return | endif
  let l:reg_save = @@

  let l:buflen = len(getbufline('%', 1, '$'))

  execute "normal! \<ESC>'<"
  let l:start = getcurpos()[1]
  execute "normal! \<ESC>'>"
  let l:end = getcurpos()[1]

  let l:vislen = l:end - l:start + 1


  let l:is_last = l:end == l:buflen

  execute "normal! \<ESC>gv"
  let l:curpos = getcurpos()
  call remove(l:curpos, 0)
  let l:is_start = l:start == l:curpos[0]

  let l:curpos[0] += a:count
  if l:is_start
    let l:curpos[0] = min([max([l:curpos[0], 1]), l:buflen - l:vislen + 1])
  else
    let l:curpos[0] = min([max([l:curpos[0], l:vislen]), l:buflen])
  endif

  if l:vislen != l:buflen
    execute "normal! \<ESC>"
    '<,'>delete

    if a:count < 0
      let l:move = -a:count - l:is_last
      if l:move > 0
        execute 'normal! ' .. l:move .. "\<Up>"
      endif
      put!
    else
      let l:move = a:count - 1
      if l:move > 0
        execute 'normal! ' .. l:move .. "\<Down>"
      endif
      put
    endif

    if l:is_start
      execute "normal! \<ESC>']V"
    else
      execute "normal! \<ESC>'[V"
    endif
    call cursor(l:curpos)
  else
    execute "normal! \<ESC>gv"
  endif

  let @@ = l:reg_save
endfunction

command! -count=1 MoveLineUp         call MoveLine(-<count>)
command! -count=1 MoveLineDown       call MoveLine(<count>)
command! -count=1 MoveMultiLinesUp   call MoveMultiLines(-<count>)
command! -count=1 MoveMultiLinesDown call MoveMultiLines(<count>)

nmap <silent> <Plug>(move-line-up)          :<C-u>silent execute v:count1 .. 'MoveLineUp'<CR>
nmap <silent> <Plug>(move-line-down)        :<C-u>silent execute v:count1 .. 'MoveLineDown'<CR>
vmap <silent> <Plug>(move-multi-lines-up)   :<C-u>silent execute v:count1 .. 'MoveMultiLinesUp'<CR>
vmap <silent> <Plug>(move-multi-lines-down) :<C-u>silent execute v:count1 .. 'MoveMultiLinesDown'<CR>



" --- my settings ---

" nmap <C-k> <Plug>(move-line-up)
" nmap <C-j> <Plug>(move-line-down)
"
" vmap <C-k> <Plug>(move-multi-lines-up)
" vmap <C-j> <Plug>(move-multi-lines-down)

