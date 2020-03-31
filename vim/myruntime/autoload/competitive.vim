
let s:F = vital#vital#import('System.Filepath')

function! competitive#start() abort
  let g:lsp_diagnostics_enabled = 0
  let g:lsp_auto_enable = 0

  if has('vim_starting')
    augroup competetive-programming
      autocmd!
      autocmd VimEnter * ++once call competitive#start()
    augroup END
    return
  endif

  echo "Competitive programming mode is running..."
  echo exists('*lsp#disable')

  if exists('*lsp#disable')
    silent! call lsp#disable()
  endif
  augroup competetive-programming
    autocmd!
    autocmd User lsp_setup ++once call lsp#disable()
  augroup END

  augroup competitive-programming-cpp
    autocmd!
    autocmd Filetype cpp call <SID>cp_cpp()
  augroup END

  " <Leader>f#{a} で :e #{a}.cpp
  for i in range(char2nr("a"), char2nr("z"))
    execute
          \"nnoremap <Leader>f" .. nr2char(i) .. " " ..
          \":e " .. nr2char(i) .. ".cpp\<CR>"
  endfor
endfunction

function! s:cp_cpp()
  " <Leader><F#{i}>
  " clipboard を "%:r" .. _in#{i} に F#{i} キーで保存
  for i in range(1, 9)
    let l:file_expand = '" .. expand("%:r") .. "_in' .. i
    execute
          \"nnoremap <silent> <expr><buffer> <Leader><F" .. i ..
          \'> ":e ' .. l:file_expand .. '<CR>' ..
          \'ggVG\"+P:w!<CR>2<C-O>' ..
          \':bd ' .. l:file_expand .. '<CR>' ..
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

function! competitive#ready(dir) abort
  if !isdirectory(a:dir)
    return 0
  endif
  let dot_compete = s:F.join(a:dir, ".compete")
  return isdirectory(dot_compete) || filereadable(dot_compete)
endfunction

function! competitive#compete(dir) abort
  call competitive#start()
  if !isdirectory(a:dir)
    return
  endif
  let dot_compete = s:F.join(a:dir, ".compete")
  echom dot_compete
  if !filereadable(dot_compete)
    silent! call writefile([''], dot_compete)
  endif
endfunction

