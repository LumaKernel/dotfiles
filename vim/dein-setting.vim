
filetype plugin indent off
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  exe '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

let &runtimepath = s:dein_repo_dir .. ',' .. &runtimepath

let s:dir = expand('<sfile>:h')

let g:quickrun_config = get(g:, 'quickrun_config', {})
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

  call dein#end()

  call dein#call_hook('source')

  call dein#save_state()
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif


" プラグイン開発用
let s:make_plugin_dir = expand('~/vim-make-plugin')
for s:path in glob(s:make_plugin_dir .. '/*', 0, 1)
  let s:skip = 0
  let s:skipfile = s:path .. '/' .. ',skip'
  if filereadable(s:skipfile)
    let s:skip = 1
    let s:file = ''
    sil! let s:file = readfile(s:skipfile)[0]
    if s:file =~# '0'
      let s:skip = 0
    endif
  endif
  if !s:skip && isdirectory(s:path)
    let &rtp = s:path .. ',' .. &rtp
    let &rtp ..= ',' .. s:path .. '/after'
  endif
endfor


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
