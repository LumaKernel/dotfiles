
function! VimAndTmuxMove(direction, skipvim)
  if $TMUX ==# ''
    silent! exe 'wincmd ' .. a:direction
  elseif a:skipvim
    silent! call TmuxMove(a:direction)
  else
    let oldw = winnr()
    silent! exe 'wincmd ' .. a:direction
    let neww = winnr()
    if oldw == neww
      silent! call TmuxMove(a:direction)
    endif
  endif
  return ''
endfunction

function! TmuxMove(direction)
  if a:direction == 'j'
    call system("tmux select-pane -D")
  elseif a:direction == 'k'
    call system("tmux select-pane -U")
  elseif a:direction == 'h'
    call system("tmux select-pane -L")
  elseif a:direction == 'l'
    call system("tmux select-pane -R")
  endif
endfunction
