function! DefineColors() abort
  let bg_tup = s:toTuple(synIDattr(hlID('Normal'), 'bg#'))

  let warning_bg = s:toString(s:col_mult(bg_tup, [2, 2, 1]))
  let error_bg   = s:toString(s:col_mult(bg_tup, [3, 1, 1]))
  let info_bg    = s:toString(s:col_mult(bg_tup, [1, 1, 3]))

  exe 'hi Warning ctermbg=58  guibg=' .. warning_bg
  exe 'hi Error   cterm=NONE ctermbg=160 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. error_bg
  exe 'hi Info    cterm=NONE ctermbg=18 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. info_bg
endfunction


" string to tuple
function! s:toTuple(text) abort
  return [str2nr(a:text[1:2], 16), str2nr(a:text[3:4], 16), str2nr(a:text[5:6], 16)]
endfunction

function! s:col_mult(tup, mul) abort
  return map(range(3), {idx -> min([max([float2nr(a:tup[idx] * a:mul[idx]), 0]), 255])})
endfunction

" tuple to string
function! s:toString(tup) abort
  return '#' .. printf('%02x', a:tup[0]) .. printf('%02x', a:tup[1]) .. printf('%02x', a:tup[2])
endfunction


autocmd init_vim Syntax * :call DefineColors()
call DefineColors()

