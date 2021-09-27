
" 自分のプラグインに対する設定を書いている節がある

nnoremap <silent> tt :<C-u>call translate_it#cword_or_close()<CR>
xnoremap <silent> tt :<C-u>call translate_it#visual()<CR>

function! CloseRemainedFloat() abort
  silent! call coc#float#close_all()
  for win_id in nvim_tabpage_list_wins(0)
    let config = nvim_win_get_config(win_id)
    if get(config, 'relative') isnot ''
      call nvim_win_close(win_id, 1)
    endif
  endfor
endfunction


if has('nvim')
  nnoremap <silent> <C-L> :<C-U>call CloseRemainedFloat()<CR><C-L>
endif

finish

function s:dump() abort
  return string([&nu, &rnu])
endfunction

let s:evs = ['BufLeave', 'BufEnter', 'BufNew', 'WinNew', 'WinEnter', 'WinLeave', 'InsertLeave', 'InsertEnter', 'FocusGained', 'FocusLost']

augroup DEBUG-eventcheck
  autocmd!
  for s:ev in s:evs
    execute printf('autocmd %s * ++nested
              \ echom "%s" &ft s:dump()', s:ev, s:ev)
  endfor
augroup END

finish

command! -bar LoadMesDebug call setqflist(json_decode(readfile(expand('.dev/debug.json')))) | Cedit

try
  echom v:throwpoint
  echom v:exception
  set rtp+=~/vim-make-plugin/vim-messages-qf
  call mkdir('.dev', 'p')
  call messages_qf#util#dump('.dev/debug.json')
catch
endtry
