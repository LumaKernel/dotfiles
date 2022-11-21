if exists("s:loaded")
  finish
endif
let s:loaded = 1

let g:merlin_disable_default_keybindings = 1
let g:opamshare = substitute(system('opam var share'),'\n$','','''')
" execute "source " . g:opamshare . "/merlin/vim/indent/ocaml.vim"
runtime! ftplugin/ocaml.vim
nnoremap gt <CMD>:MerlinLocateType<CR>
