
" 自分のプラグインに対する設定を書いている節がある

nnoremap <silent> tt :<C-u>call translate_it#cword_or_close()<CR>
xnoremap <silent> tt :<C-u>call translate_it#visual()<CR>

command! -bar MessagesQF call g:messages_qf#messages() | Cedit
command! -bar SaveMes call writefile([json_encode(g:messages_qf#parse_messages(split(execute('messages','silent!'),"\n")))],expand('~/.cache/vim.messages.json'))
command! -bar LoadMes call setqflist(json_decode(readfile(expand('~/.cache/vim.messages.json')))) | Cedit

command! -bar SaveMesThemis call message_qf#util#dump('~/.cache/vim.messages.themis.json') | Cedit

command! -bar LoadMesDebug call setqflist(json_decode(readfile(expand('.dev/debug.json')))) | Cedit

function! CloseRemainedFloat() abort
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

try
  echom v:throwpoint
  echom v:exception
  set rtp+=~/vim-make-plugin/vim-messages-qf
  call mkdir('.dev', 'p')
  call messages_qf#util#dump('.dev/debug.json')
catch
endtry

