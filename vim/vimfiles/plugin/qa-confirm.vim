" 「vimを10分以上起動していたら '最後の:q と :q!' , ':qa', ':qa!' は確認をとる」

function s:cache() abort
  let s:cmdline = getcmdline()
endfunction

function s:confirm_quit() abort
  if s:cmdline == 'q' || s:cmdline == 'q!'
    if winnr('$') == 1 && tabpagenr('$') == 1
      return confirm('Are you sure to :quit ?', "&Yes\n&No", 2, 'Question') == 1 ? s:cmdline : ''
    endif
  elseif s:cmdline == 'qa' || s:cmdline == 'qa!'
    return confirm('Are you sure to :qall ?', "&Yes\n&No", 2, 'Question') == 1 ? s:cmdline : ''
  endif
  return s:cmdline
endfunction

function s:set_confirm_quit(...) abort
  augroup vim_init
    au CmdlineEnter : cnoremap <CR> <C-r>=<SID>cache()<CR><C-e><C-u><C-r>=<SID>confirm_quit()<CR><CR>
    au CmdlineLeave : cunmap <CR>
  augroup END
endfunction

call timer_start(1000 * 60 * 10, function('s:set_confirm_quit'))

