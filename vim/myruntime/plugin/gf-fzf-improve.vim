function! s:fzfize(fname) abort
  let fname = a:fname
  let fname = substitute(fname, '^\~/', '', '')

  if len(filter(split(fname, '\zs'), {i, v -> v ==# '.'})) > 1
    let fname = reverse(split(fname, '[/.\[:space:]]\+'))
  else
    let fname = reverse(split(fname, '[/\[:space:]]\+'))
  endif

  let pat = '\(\.[^.]\+\)$'

  if fname[0] =~# pat
    let ext = matchstr(fname[0], pat)
    let fname[0] = substitute(fname[0], pat, '', '')
    call add(fname, ext)
  endif

  let fname = join(fname, ' ')

  return fname
endfunction

function! s:vcs_root(from) abort
  let from = a:from
  let from = fnamemodify(from, ':p')
  if filereadable(from)
    let from = fnamemodify(from, ':h')
  endif

  let start = from
  let last = from
  let s:F = vital#vital#import('System.Filepath')

  while 1
    if isdirectory(from .. s:F.separator() .. '.git')
      return from
    endif
    let from = fnamemodify(from, ':h')
    if strlen(last) <= strlen(from) || s:F.is_root_directory(from)
      break
    endif
  endwhile

  return start
endfunction

function! GF_fzf_improve(from, target, search_vcs_root) abort
  let from = a:from
  let target = a:target

  let from = fnamemodify(from, ':p')

  if filereadable(from)
    let from = fnamemodify(from, ':h')
  endif

  let cwd = getcwd()
  let s:F = vital#vital#import('System.Filepath')
  if s:F.contains(from, cwd)
    let from = cwd
  endif

  if a:search_vcs_root
    let from = s:vcs_root(from)
  endif

  call fzf#run(fzf#wrap({
        \   'dir': from,
        \   'options': printf('--select-1 --query="%s"', s:fzfize(target)),
        \ }))
endfunction

nnoremap <silent> gf :<C-u>call GF_fzf_improve(expand('%'), expand('<cfile>'), 0)<CR>
nnoremap <silent> gF :<C-u>call GF_fzf_improve(expand('%'), expand('<cfile>'), 1)<CR>
