let g:my_color_fixes = get(g:, 'g:my_color_fixes', {})

let g:miss_spells = [
      \   'functoin',
      \   'funciton',
      \   'functino',
      \   'optino',
      \   'optoin',
      \   'ehco',
      \   'itn',
      \   'teh',
      \ ]

function! DefineColors() abort
  let bg_tup = s:toTuple(synIDattr(hlID('Normal'), 'bg#'))

  let warning_bg = s:toString(s:col_mult(bg_tup, [3, 2, 1]))
  let error_bg   = s:toString(s:col_mult(bg_tup, [3, 0.6, 0.6]))
  let info_bg    = s:toString(s:col_mult(bg_tup, [1, 1, 3]))

  let qf_bg    = s:toString(s:col_mult(bg_tup, [1.8, 1.8, 0.8]))

  exe 'hi Warning ctermbg=58  guibg=' .. warning_bg
  exe 'hi Error   cterm=NONE ctermbg=160 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. error_bg
  exe 'hi Info    cterm=NONE ctermbg=18 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. info_bg

  exe 'hi QuickFixLine    cterm=NONE ctermbg=17 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. qf_bg
  exe 'hi ColorColumn    cterm=NONE ctermbg=17 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. warning_bg

  if exists('g:colors_name') && has_key(g:my_color_fixes, g:colors_name)
    call g:my_color_fixes[g:colors_name]()
  endif

endfunction

hi link MySpellError Error
exe 'match MySpellError ' .. '/' .. join(g:miss_spells, '\|') .. '/'

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


" カラースキームごとの設定
" 量が増えたら外部ファイルへ


" tender {{{

function! g:my_color_fixes.tender()
  hi Comment guifg=#999999
  hi Ignore ctermfg=125 guifg=#994444
endfunction

" }}}

" iceberg {{{

function! g:my_color_fixes.iceberg()
  hi Comment guifg=#999999
  hi Ignore ctermfg=125 guifg=#994444
  hi Constant guifg=#cc99cc
endfunction

" }}}

" onedark {{{

function! g:my_color_fixes.onedark()
  hi Comment guifg=#999999
  hi Comment ctermfg=244
  " hi Error ctermbg=52
endfunction

" }}}


autocmd init_vim Syntax * :call DefineColors()
call DefineColors()

