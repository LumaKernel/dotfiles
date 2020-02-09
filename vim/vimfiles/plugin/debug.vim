
" 自分のプラグインに対する設定を書いている節がある

nnoremap <silent> tt :<C-u>call translate_it#cword_or_close()<CR>
xnoremap <silent> tt :<C-u>call translate_it#visual()<CR>

command! MessagesQF call g:messages_qf#messages() | copen
command! SaveMes call writefile([json_encode(g:messages_qf#parse_messages(split(execute('messages','silent!'),"\n")))],expand('~/.cache/vim.messages.json'))
command! LoadMes call setqflist(json_decode(readfile(expand('~/.cache/vim.messages.json')))) | copen

