function! s:get_coc() abort
  return luaeval('require"my_coc_near_getter"()')
endfunction

function! s:my_file() abort
  let shortmess_s = &shortmess
  set shortmess=asToOFcI
  try
    let file = trim(execute('file'))
    let coc = ''
    if has('nvim') && g:lsp_mode == 'coc'
      let coc = s:get_coc()
    endif
    if empty(coc)
      return file
    endif
    return coc . ' ' . file
  finally
    let &shortmess = shortmess_s
  endtry
endfunction

function! s:my_file() abort
  let shortmess_s = &shortmess
  set shortmess=asToOFcI
  try
    let file = trim(execute('file'))
    let coc = ''
    if has('nvim') && g:lsp_mode == 'coc'
      let coc = luaeval('require"my_coc_near_getter"()')
    endif
    if empty(coc)
      return file
    endif
    return coc . ' ' . file
  finally
    let &shortmess = shortmess_s
  endtry
endfunction

function! s:my_show_file() abort
  echo s:my_file()
endfunction

function! s:my_show_coc() abort
  echo s:get_coc()
endfunction

nnoremap <silent> <c-s> :<c-u>call <SID>my_show_coc()<cr>
