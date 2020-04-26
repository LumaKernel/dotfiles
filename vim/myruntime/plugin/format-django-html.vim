let s:django_block_start = '\%(if\|else\|block\|for\|comment\)'
let s:django_block_end = '\%(endif\|else\|endblock\|endfor\|endcomment\)'
let s:django_oneline_start = '^\s*{%\s*' . s:django_block_start . '\s*[^%]*%}$'
let s:django_oneline_end = '^\s*{%\s*' . s:django_block_end . '\s*[^%]*%}$'

function! s:FormatDjangoHTML() abort
  let curpos = getcurpos()
  let winview = winsaveview()

  normal! ggVG=
  let lines = getbufline('', 1, '$')
  let add = 0
  for i in range(len(lines))
    let lnum = i + 1
    let line = lines[i]
    if line =~? s:django_oneline_end
      let add -= 1
      if add < 0
        let add = 0
      endif
    endif
    if add > 0
      execute printf('normal! %dgg%s', lnum, repeat('>>', add))
    endif
    if line =~? s:django_oneline_start
      let add += 1
    endif
  endfor

  let ft_save = &ft
  set ft=xml
  let start = 0
  for i in range(len(lines))
    let lnum = i + 1
    let line = lines[i]
    if line =~? '^\s*</svg'
      if start
        execute printf('normal! %dggV%dgg=', from, lnum - 1)
      endif
      let start = 0
    endif
    if line =~? '^\s*<svg'
      let from = lnum + 1
      let start = 1
    endif
  endfor
  let &ft = ft_save

  call winrestview(winview)
  call setpos('.', curpos)
endfunction

command! FormatDjangoHTML call <SID>FormatDjangoHTML()


