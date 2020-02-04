
function! TmuxMove(direction)
  if $TMUX ==# ''
    silent! exe 'wincmd ' .. a:direction
  else
    let oldw = winnr()
    silent! exe 'wincmd ' .. a:direction
    let neww = winnr()
    if oldw == neww
      if a:direction == 'j'
        call system("tmux select-pane -D")
      elseif a:direction == 'k'
        call system("tmux select-pane -U")
      elseif a:direction == 'h'
        call system("tmux select-pane -L")
      elseif a:direction == 'l'
        call system("tmux select-pane -R")
      endif
    else
  endif
endfunction

