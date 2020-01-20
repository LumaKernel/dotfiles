
filetype plugin indent off
let s:dein_dir = '~/.cache/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath

let s:dir = expand('<sfile>:h')

let g:quickrun_config = get(g:, 'quickrun_config', {})
if dein#load_state(s:dein_dir)

  call dein#begin(s:dein_dir)

    call dein#add(s:dein_dir)

    call dein#add(resolve(s:dir .. '/vimfiles'), { 'merged' : 0 })

    for s:toml in glob(s:dir .. '/plugin-install/*.toml', 1, 1)
      call dein#load_toml(s:toml)
    endfor

    for s:toml in glob(s:dir .. '/plugin-install/filetypes/*.toml', 1, 1)
      call dein#load_toml(s:toml)
    endfor

  call dein#end()

  call dein#call_hook('source')

  call dein#save_state()
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif

augroup init_vim
  if v:vim_did_enter
    call dein#call_hook('post_source')
  else
    autocmd VimEnter * call dein#call_hook('post_source')
  endif
augroup END

filetype plugin indent on


let s:F = vital#vital#import('System.File')

function! DeinClean() abort
  for l:dir in dein#check_clean()
    call s:F.rmdir(l:dir, 'r')
  endfor
  call dein#update()
endfunction

command! DeinClean call DeinClean()

