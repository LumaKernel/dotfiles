
" 自分のプラグインに対する設定を書いている節がある

nnoremap <silent> tt :<C-u>call translate_it#cword_or_close()<CR>
xnoremap <silent> tt :<C-u>call translate_it#visual()<CR>

command! -bar MessagesQF call g:messages_qf#messages() | Cedit
command! -bar SaveMes call writefile([json_encode(g:messages_qf#parse_messages(split(execute('messages','silent!'),"\n")))],expand('~/.cache/vim.messages.json'))
command! -bar LoadMes call setqflist(json_decode(readfile(expand('~/.cache/vim.messages.json')))) | Cedit

command! -bar SaveMesThemis call message_qf#util#dump('~/.cache/vim.messages.themis.json')

