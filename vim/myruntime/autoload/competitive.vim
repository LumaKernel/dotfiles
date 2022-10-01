
function! competitive#start() abort
  let g:competitive_started = 1
  let g:lsp_diagnostics_enabled = 0
  let g:lsp_auto_enable = 0

  if has('vim_starting')
    augroup competetive-programming
      autocmd!
      autocmd VimEnter * ++once call competitive#start()
    augroup END
    return
  endif

  if exists('*lsp#disable')
    silent! call lsp#disable()
  endif
  augroup competetive-programming
    autocmd!
    autocmd User lsp_setup ++once call lsp#disable()
  augroup END

  call s:cp()

  augroup competitive-programming-cpp
    autocmd!
    autocmd Filetype cpp call <SID>cp_cpp()
  augroup END

  augroup competitive-programming-rs
    autocmd!
    autocmd Filetype rust call <SID>cp_rs()
  augroup END

  augroup competitive-programming-in-txt
    autocmd!
    autocmd BufRead,BufNewFile *.in.txt call <SID>cp_in_txt()
  augroup END
endfunction

function! s:cp()
  call s:cp_cpp_src()
  call s:cp_rs_src()
endfunction

function! s:cp_cpp()
  call s:cp_input()
endfunction

function! s:cp_rs()
  call s:cp_input()
  call s:cp_rs_run()
endfunction

function! s:cp_in_txt()
  call s:cp_input_input()
endfunction

function! s:on_after_src_open()
  let is_empty = getbufinfo('.')[0].linecount ==# 1 && line('.') ==# ''
  if is_empty
    return ":Template \<Tab>"
  endif
  return ""
endfunction

function! s:cp_cpp_src()
  " <Leader>f#{a} で :e #{a}.cpp
  for i in range(char2nr("a"), char2nr("z"))
    execute
          \"nnoremap <Leader>f" .. nr2char(i) .. " " ..
          \":e " .. nr2char(i) .. ".cpp\<CR>"
  endfor
endfunction

function! s:cp_rs_src_expr(c)
  let after_open = ''
  if !filereadable("src/bin/" .. a:c .. ".rs")
    let after_open = ":Template "
  endif
  return ":call mkdir('input/" .. a:c .. "', 'p') | e src/bin/" .. a:c .. ".rs " .. " \<CR>" .. after_open
endfunction

function! s:cp_rs_src()
  " <Leader>g#{a} で :e #{a}.rs
  for i in range(char2nr("a"), char2nr("z"))
    execute
          \"nnoremap <expr><Leader>g" .. nr2char(i) .. " <SID>cp_rs_src_expr('" .. nr2char(i) .. "')"
  endfor
endfunction

function! s:cp_clipboard_input()
  " <Leader>#{i}
  " clipboard を "%:r" .. _in#{i} に F#{i} キーで保存
  for i in range(1, 9)
    let l:file_expand = '" .. expand("%:r") .. "_in' .. i
    execute
          \"nnoremap <silent> <expr><buffer> <Leader>" .. i ..
          \' ":e ' .. l:file_expand .. '<CR>' ..
          \'ggVG\"+P:w!<CR>2<C-O>' ..
          \':bd ' .. l:file_expand .. '<CR>' ..
          \':echo \"ready, ' .. l:file_expand .. '\"<CR>"'
  endfor
endfunction

function! s:cp_input()
  " <Leader>i#{a}
  for i in range(char2nr("a"), char2nr("z"))
    let l:file_expand = 'input/" .. expand("%:t:r") .. "/' .. nr2char(i) .. ".in.txt"
    execute
          \"nnoremap <expr><buffer> <Leader>i" .. nr2char(i) ..
          \' ":e ' .. l:file_expand .. '<CR>"'
  endfor
endfunction

function! s:cp_input_input()
  " <Leader>i#{a}
  for i in range(char2nr("a"), char2nr("z"))
    let l:file_expand = 'input/" .. expand("%:h:t") .. "/' .. nr2char(i) .. ".in.txt"
    execute
          \"nnoremap <expr><buffer> <Leader>i" .. nr2char(i) ..
          \' ":e ' .. l:file_expand .. '<CR>"'
  endfor
endfunction

function! s:cp_cpp_run()
  " <Leader>#{i} で "%:r" .. _in#{i} を input として % を実行
  for i in range(1, 9)
    execute
          \'nnoremap <expr><buffer> <Leader>' .. i ..
          \' ":ccl\|QuickRun -input " .. expand("%:r") .. "_in' .. i ..
          \'\<CR>"'
  endfor
endfunction

function! s:cp_rs_run()
  " <Leader>k#{i}
  for i in range(char2nr("a"), char2nr("z"))
    if nr2char(i) ==# 'k'
      continue
    endif
    execute
          \'nnoremap <expr><buffer> <Leader>k' .. nr2char(i) ..
          \' ":ccl\|QuickRun' ..
          \' -type rust_cp' ..
          \' -input input/" .. expand("%:t:r") .. "/' .. nr2char(i) .. '.in.txt' ..
          \'\<CR>"'
  endfor

  " <Leader>kk#{i}
  for i in range(char2nr("a"), char2nr("z"))
    if nr2char(i) ==# 'k'
      continue
    endif
    execute
          \'nnoremap <expr><buffer> <Leader>kk' .. nr2char(i) ..
          \' ":ccl\|QuickRun' ..
          \' -type rust_cp_v' ..
          \' -input input/" .. expand("%:t:r") .. "/' .. nr2char(i) .. '.in.txt' ..
          \'\<CR>"'
  endfor
endfunction

function! competitive#ready(dir) abort
  let s:F = vital#vital#import('System.Filepath')
  if !isdirectory(a:dir)
    return 0
  endif
  let dot_compete = s:F.join(a:dir, ".cp")
  return isdirectory(dot_compete) || filereadable(dot_compete)
endfunction

function! competitive#compete(dir) abort
  let s:F = vital#vital#import('System.Filepath')
  call competitive#start()
  if !isdirectory(a:dir)
    return
  endif
  let dot_compete = s:F.join(a:dir, ".cp")
  if !filereadable(dot_compete)
    silent! call writefile([''], dot_compete)
  endif
endfunction
