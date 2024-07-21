const s:dpp_base = expand('~/.cache/dpp')

const s:dpp_src = s:dpp_base .. '/repos/github.com/Shougo/dpp.vim'
const s:denops_src = s:dpp_base .. '/repos/github.com/vim-denops/denops.vim'

if !isdirectory(s:dpp_src)
  execute '!git clone https://github.com/Shougo/dpp.vim' s:dpp_src
endif
if !isdirectory(s:denops_src)
  execute '!git clone https://github.com/vim-denops/denops.vim' s:denops_src
endif

let denops#debug = 1

execute 'set runtimepath^=' .. s:dpp_src

if dpp#min#load_state(s:dpp_base)
  augroup my-dpp-setup
    autocmd!
    autocmd User DenopsReady unsilent echom 4
    autocmd User DenopsReady
      \ call dpp#make_state(s:dpp_base, '/Users/luma/dotfiles/demo-conifg/main.ts')
  augroup END
  execute 'set runtimepath^=' .. s:denops_src
endif
