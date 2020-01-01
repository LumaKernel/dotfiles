
filetype plugin indent off
let s:dein_dir = '~/.cache/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath

let g:quickrun_config = get(g:, 'quickrun_config', {})
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
    call dein#add('~/.cache/dein')
    call dein#load_toml('~/dotfiles/vimfiles/toml/general.toml')
    call dein#load_toml('~/dotfiles/vimfiles/toml/airline.toml')

    for s:toml in glob('~/dotfiles/vimfiles/toml/filetypes/*.toml', 1, 1)
      call dein#load_toml(s:toml)
    endfor
  call dein#end()
  call dein#call_hook('source')

  call dein#save_state()
  if has('vim_starting') && dein#check_install()
    silent call dein#install()
  endif
endif

augroup my_dein_hook
  au!
  if v:vim_did_enter
    echom "not enter" | call dein#call_hook('post_source')
  else
    autocmd VimEnter * echom "enter" | call dein#call_hook('post_source')
  endif
augroup END

filetype plugin indent on


let s:F = vital#vital#import('System.File')

function! DeinClean() abort
  for l:dir in dein#check_clean()
    call s:F.rmdir(l:dir, 'r')
  endfor
endfunction

function! DeinCleanAll() abort
  echoerr "TODO"
endfunction

command! DeinClean call DeinClean()
command! DeinCleanAll call DeinCleanAll()


