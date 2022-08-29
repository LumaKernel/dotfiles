
command! Compete call competitive#compete(getcwd())
if competitive#ready(getcwd())
  call competitive#start()
  let g:sonictemplate_vim_template_dir = [
    \  '$HOME/dotfiles/vim/sonictemplate/cp',
    \ ]
endif
