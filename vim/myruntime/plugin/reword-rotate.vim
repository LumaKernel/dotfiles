function! s:temp() abort
  let s = 'Tmp'
  for i in range(1, 8)
    let s .= printf('%02x', rand())
  endfor
  return s
endfunction

function! s:reword_rotate(line1, line2, ...) abort
  let tmp = s:temp()
  let words = [tmp] + a:000
  for i in range(len(words))
    let word_to = words[i]
    let word_from = words[(i + 1) % len(words)]
    let cmd = printf('%d,%dReword/%s/%s/g', a:line1, a:line2, word_from, word_to)
    execute cmd
  endfor
endfunction

command! -range -nargs=+ RewordRotate call <SID>reword_rotate(<line1>, <line2>, <f-args>)
