
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

let s:api_token_path = expand('~/dotfiles/.apikey')
if filereadable(s:api_token_path)
  let g:dein#install_github_api_token = get(readfile(s:api_token_path), 0, '')
endif


filetype plugin indent off
let g:dein_ns = printf(
  \ '%s--%s--%s--%s',
  \ g:mode,
  \ g:complete_mode,
  \ g:lsp_mode,
  \ g:ts_lsp_mode
\ )
let g:dein_dir = has('nvim') ? expand(printf('~/.cache/dein/nvim-%s', g:dein_ns)) : expand(printf('~/.cache/dein/vim-%s', g:dein_ns))
let g:dein_repo_dir = g:dein_dir .. '/repos/github.com/Shougo/dein.vim'

if !isdirectory(g:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' g:dein_repo_dir
endif

let &runtimepath = g:dein_repo_dir .. ',' .. &runtimepath

let s:dir = expand('<sfile>:h')

if dein#load_state(g:dein_dir)
  call dein#begin(g:dein_dir)
    call dein#add(g:dein_dir)
    call dein#add(resolve(s:dir .. '/myruntime'), { 'merged' : 1 })
    call dein#load_toml(s:dir .. '/plugin-install/common.toml')
    if g:mode is# 'huge'
      call dein#load_toml(s:dir .. '/plugin-install/huge.toml')
    endif
    if g:complete_mode is# 'ddc'
      call dein#load_toml(s:dir .. '/plugin-install/ddc.toml')
    endif
    if g:complete_mode is# 'coc' && g:lsp_mode is# 'coc'
      call dein#load_toml(s:dir .. '/plugin-install/coc.toml')
      call dein#load_toml(s:dir .. '/plugin-install/ddc.toml')
    endif
    if g:lsp_mode is# 'vim-lsp'
      call dein#load_toml(s:dir .. '/plugin-install/vim-lsp.toml')
    endif
    " call s:dein_opam_settings()
  call dein#end()
  call dein#call_hook('source')
  call dein#save_state()
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif

filetype plugin indent on

augroup init_vim
  if v:vim_did_enter
    call dein#call_hook('post_source')
  else
    autocmd VimEnter * call dein#call_hook('post_source')
  endif
augroup END


function! DeinClean() abort
  let s:F = vital#vital#import('System.File')
  for l:dir in dein#check_clean()
    call s:F.rmdir(l:dir, 'r')
  endfor
  call dein#check_update()
  call dein#recache_runtimepath()
  call dein#remote_plugins()
endfunction

command! DeinClean call DeinClean()
