
" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")

nnoremap <Leader>; :VimShowHlGroup<CR>
nnoremap <Leader>: :VimShowHlItem<CR>


let g:my_color_fixes = get(g:, 'g:my_color_fixes', {})

function! DefineColors() abort
  let bg_tup = s:toTuple(synIDattr(hlID('Normal'), 'bg#'))

  let warning_bg = s:toString(s:col_mult(bg_tup, [1.52, 1.3, 0.5]))
  let error_bg   = s:toString(s:col_mult(bg_tup, [1.8, 0.8, 0.8]))
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
  hi Error ctermbg=52 guibg=#661111
endfunction

" }}}

" onedark {{{

function! g:my_color_fixes.edge()
  hi Error ctermbg=52 guibg=#661111
endfunction

" }}}

" sierra {{{

function! g:my_color_fixes.iceberg()
  hi Error ctermbg=52 guibg=#400000
endfunction

" }}}

" seoul256 {{{

function! g:my_color_fixes.seoul256()
  hi Comment guifg=#999999
  hi Comment ctermfg=244
endfunction

" }}}

" PaperColor {{{

function! g:my_color_fixes.PaperColor()
  hi Comment guifg=#BBBBBB
  hi Error guibg=#5f0000
  hi Warning guibg=#434300 guifg=White
  hi Comment ctermfg=244
endfunction

" }}}


augroup my-color-syntax
  autocmd ColorScheme * call DefineColors()
augroup END
call DefineColors()


function! DefineMyPythonColors() abort
  hi link MyPythonSyntaxError Error
  match MyPythonSyntaxError /\<else\s*if\>/
endfunction

augroup my-python-syntax
  autocmd FileType python,htmldjango call DefineMyPythonColors()
augroup END
