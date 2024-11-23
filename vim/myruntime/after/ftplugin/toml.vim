if g:huge_mode ==# 'yes'
  if expand("%:p") =~? '/plugin-install/'
    call timer_start(0, {-> dein#toml#syntax()})
  endif
endif
