
command! RemoveCR %s/\r//g

nnoremap <Leader>m :<C-u>RemoveCR<CR>

