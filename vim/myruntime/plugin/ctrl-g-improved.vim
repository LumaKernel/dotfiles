function! s:my_file() abort
  let shortmess_s = &shortmess
  set shortmess=asToOFcI
  try
    let file = trim(execute('file'))
    return file
  finally
    let &shortmess = shortmess_s
  endtry
endfunction

function! s:my_show_file() abort
  echo s:my_file()
endfunction
