let s:varname = 'flex_relnumber_rnu_saved'

augroup flex_relnumber
  autocmd BufNew,BufEnter,FocusGained,InsertLeave,WinEnter * ++nested
        \   if &nu && !&rnu && !has_key(w:, s:varname)
        \ |   let w:[s:varname] = 0
        \ |   setlocal rnu
        \ | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave * ++nested
        \   if &nu && &rnu && has_key(w:, s:varname)
        \ |   let &rnu = 1
        \ |   unlet w:[s:varname]
        \ | endif
augroup END
