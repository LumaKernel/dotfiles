
filetype plugin indent off
let s:dein_dir = '~/.cache/dein'
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'
let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
    call dein#add('~/.cache/dein')
    call dein#load_toml('~/dotfiles/vimfiles/dein.toml')
  call dein#end()

  call dein#save_state()
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif
augroup my_dein_hook
  autocmd VimEnter * call dein#call_hook('post_source')
augroup END
filetype plugin indent on
