
function! VimAndTmuxMove(direction, skipvim)
  if $TMUX ==# '' || !executable('tmux')
    if !a:skipvim
      silent! exe 'wincmd ' .. a:direction
    endif
  elseif system(["tmux", "display", "-p", "#{window_zoomed_flag}"]) =~# '1'
    if !a:skipvim
      silent! exe 'wincmd ' .. a:direction
    endif
  elseif a:skipvim
    silent! call s:TmuxMove(a:direction)
  else
    let oldw = winnr()
    silent! exe 'wincmd ' .. a:direction
    let neww = winnr()
    if oldw == neww
      silent! call s:TmuxMove(a:direction)
    endif
  endif
  return ''
endfunction

function! s:TmuxMove(direction)
  if a:direction == 'j'
    call system("tmux select-pane -D")
  elseif a:direction == 'k'
    call system("tmux select-pane -U")
  elseif a:direction == 'h'
    call system("tmux select-pane -L")
  elseif a:direction == 'l'
    call system("tmux select-pane -R")
  endif
  return ''
endfunction
