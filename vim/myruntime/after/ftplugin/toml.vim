if g:mode ==# 'huge'
  if expand("%:p") =~? '/plugin-install/'
    call timer_start(0, {-> dein#toml#syntax()})
  endif
endif
