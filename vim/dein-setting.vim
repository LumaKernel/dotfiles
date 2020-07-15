
function! s:dein_opam_settings() abort
  if executable('opam')
    let opamshare = substitute(system('opam config var share'),'\n$','','')
    let plugins = ['/merlin/vim', '/ocp-indent/vim']
    for plugin in plugins
      let path = opamshare .. plugin
      if isdirectory(path)
        call dein#add(path, { 'name': 'opam-share-plugins' .. substitute(plugin, '/', '-', '') })
      endif
    endfor
  endif
endfunction


filetype plugin indent off
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath

let s:dir = expand('<sfile>:h')

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
    call dein#add(s:dein_dir)
    call dein#add(resolve(s:dir .. '/myruntime'), { 'merged' : 1 })
    for s:toml in glob(s:dir .. '/plugin-install/*.toml', 1, 1)
      call dein#load_toml(s:toml)
    endfor
    for s:toml in glob(s:dir .. '/plugin-install/filetypes/*.toml', 1, 1)
      call dein#load_toml(s:toml)
    endfor
    call s:dein_opam_settings()
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
  call dein#recache_runtimepath()
  call dein#remote_plugins()
endfunction

command! DeinClean call DeinClean()
