set encoding=utf-8
scriptencoding utf-8

" コメント方針 : 適当に書く．日本語で書く．
"   ぶっちゃけ理解したものは消す
"   :help を，見ろ

let g:from_pwsh = !has('nvim') && $RunFromPowershell ==# '1'


function! DefineColors() abort
  let bg_tup = s:toTuple(synIDattr(hlID('Normal'), 'bg#'))

  let warning_bg       = s:toString(s:col_mult(bg_tup, [2, 2, 1]))
  let error_bg       = s:toString(s:col_mult(bg_tup, [3, 1, 1]))

  exe 'hi Warning ctermbg=58  guibg=' .. warning_bg
  exe 'hi Error   cterm=NONE ctermbg=160 ctermfg=NONE gui=NONE guifg=NONE guibg=' .. error_bg
  " exe 'hi Error   ctermbg=160 guibg=' .. error_bg
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


augroup my_color_define
  au!
  autocmd Syntax * :call DefineColors()
augroup END
call DefineColors()


let g:mapping_descriptions = []

source ~/dotfiles/vimfiles/option-basic.vim
source ~/dotfiles/vimfiles/mapping.vim
source ~/dotfiles/vimfiles/dein-setting.vim
source ~/dotfiles/vimfiles/show-whitespace.vim
source ~/dotfiles/vimfiles/openapps.vim
source ~/dotfiles/vimfiles/gvim.vim

source ~/dotfiles/vimfiles/setup-powershell.vim

source ~/dotfiles/vimfiles/cpp.vim
source ~/dotfiles/vimfiles/competitive-programming.vim

source ~/dotfiles/vimfiles/vimscript.vim


