function! s:RestoreRegister()
  let @d = @"
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl(sid)
    let s:restore_reg = @"
    return "p:call " .. a:sid .. "RestoreRegister()\<CR>"
endfunction


" -- user settings

vnoremap <silent><expr> p <SID>Repl("<SID>")

