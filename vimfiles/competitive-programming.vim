
au FileType vimshell imap <buffer> <C-K> <Plug>(neosnippet_expand_or_jump)

au FileType text nnoremap <silent> <Leader>w :w!<CR>
let s:creg = has('unix') ? "+" : "*"


function! s:copyall()
  let @+ = join(getbufline(bufnr('%'), 1, '$'), "\n")
endfunction

nnoremap <silent> <Leader>c :call <SID>copyall()<CR>
exe 'nnoremap <silent> <Leader>v ggVGs<ESC>"' .. s:creg .. 'P:w!<CR>'

nmap <Leader>t ggVGstemp

" <Leader>f#{a} で :e #{a}.cpp
for i in range(char2nr("a"), char2nr("z"))
  execute
        \"nnoremap <Leader>f" .. nr2char(i) .. " " ..
        \":e " .. nr2char(i) .. ".cpp\<CR>"
endfor

function! s:cp_cpp()
  " <Leader><F#{i}>
  " clipboard を "%:r" .. _in#{i} に F#{i} キーで保存
  for i in range(1, 9)
    let l:file_expand = '" .. expand("%:r") .. "_in' .. i
    execute
          \"nnoremap <silent> <expr><buffer> <Leader><F" .. i ..
          \'> ":e ' .. l:file_expand .. '<CR>' ..
          \'ggVG\"' .. s:creg .. 'P:w!<CR>2<C-O>' ..
          \':bd ' .. l:file_expand .. '<CR>' .
          \':echo \"ready, ' .. l:file_expand .. '\"<CR>"'
  endfor

  " <Leader>e<F#{i}>
  " "%:r" .. _in#{i} を開く
  for i in range(1, 9)
    let l:file_expand = '" .. expand("%:r") .. "_in' .. i
    execute
          \"nnoremap <expr><buffer> <Leader>e" .. i ..
          \' ":e ' .. l:file_expand .. '<CR>"'
  endfor

  " <Leader>#{i} で "%:r" .. _in#{i} を input として % を実行
  for i in range(1, 9)
    execute
          \'nnoremap <expr><buffer> <Leader>' .. i ..
          \' ":ccl\|QuickRun -input " .. expand("%:r") .. "_in' .. i ..
          \'\<CR>"'
  endfor
endfunction

augroup my_cpp
  au!
  autocmd Filetype cpp call <SID>cp_cpp()
augroup END

