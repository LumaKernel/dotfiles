if 1
  finish
endif

let s:es = [
      \   'BufNew',
      \   'BufNewFile',
      \   'BufAdd',
      \   'BufCreate',
      \   'BufRead',
      \   'BufFilePre',
      \   'BufFilePost',
      \   'BufEnter',
      \   'BufLeave',
      \   'BufWinEnter',
      \   'BufWinLeave',
      \ ]

for s:e in s:es
  execute printf('autocmd %s * unsilent echom "%s: " . expand("%%")', s:e, s:e)
endfor
