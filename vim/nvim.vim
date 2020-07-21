if !has('nvim')
  finish
endif

if has('win32unix') || has('win32')
  let g:nvim_python3 = expand('$HOME/.pyenv/pyenv-win/versions/3.8.3/python.exe')
  if filereadable(g:nvim_python3)
    let g:python3_host_prog = g:nvim_python3
  endif
elseif has('unix')
  let g:nvim_python3 = expand('$HOME/.local/venvs/nvim/bin/python3')
  if filereadable(g:nvim_python3)
    let g:python3_host_prog = g:nvim_python3
  else
    echohl WarningMsg
    echomsg "[>_<] You didn't run $HOME/dotfiles/scripts/setup-nvim-python3.sh"
    echohl None
  endif
endif
