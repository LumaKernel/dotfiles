
function s:check(name, cmds, verpat) abort
  let ok = executable(a:cmds[0])
  if ok
    let ver = trim(system(a:cmds))
    if ver !~# a:verpat
      let ok = 0
    else
      let ver = matchlist(ver, a:verpat)[1]
    endif
  endif
  if ok
    call health#report_ok(printf('%s: Version %s found.', a:name, ver))
  else
    call health#report_error(printf('%s: Not found.', a:name))
  endif
endfunction

function s:checkfile(fname) abort
  if filereadable(a:fname)
    call health#report_ok(printf('%s: Found.', a:fname))
  else
    call health#report_error(printf('%s: Not found.', a:fname))
  endif
endfunction

function! health#my#check() abort
  call health#report_start('my: Info')

  call health#report_info(printf('uname -a : %s', system(['uname', '-a'])))
  call health#report_info(printf('dpkg --print-architecture : %s', system(['dpkg', '--print-architecture'])))


  call health#report_start('my: Basic Commands')

  call s:check('make', ['make', '--version'], '^GNU Make \(\d\+\.\d\+\)')
  call s:check('cmake', ['cmake', '--version'], '^cmake version \(\d\+\.\d\+\.\d\+\)')
  call s:check('find', ['find', '--version'], '^find .* \(\d\+\.\d\+\.\d\+\)')
  call s:check('zip', ['zip', '--version'], 'Zip \(\d\+\.\d\+\)')
  call s:check('vim', ['vim', '--version'], '^VIM - Vi IMproved \(\d\+\.\d\+\)')
  call s:check('nvim', ['nvim', '--version'], '^NVIM v\(\d\+\.\d\+\.\d\+\)')
  call s:check('git', ['git', '--version'], '^git version \(\d\+\.\d\+\.\d\+\)')
  call s:check('hub', ['hub', '--version'], 'hub version \(\d\+\.\d\+\.\d\+\)')
  call s:check('fzf', ['fzf', '--version'], '^\(\d\+\.\d\+\.\d\+\)')
  call s:check('npm', ['npm', '--version'], '^\(\d\+\.\d\+\.\d\+\)')
  call s:check('yarn', ['yarn', '--version'], '^\(\d\+\.\d\+\.\d\+\)')
  call s:check('deno', ['deno', '--version'], '^deno \(\d\+\.\d\+\.\d\+\)')
  call s:check('pyenv', ['pyenv', '--version'], '^pyenv \(\d\+\.\d\+\.\d\+\)')
  call s:check('pip', ['pip', '--version'], '^pip \(\d\+\.\d\+\%(\.\d\+\)\?\)')
  call s:check('brew', ['brew', '--version'], '^Homebrew \(\d\+\.\d\+\.\d\+\)')
  call s:check('cargo', ['cargo', '--version'], '^cargo \(\d\+\.\d\+\.\d\+\)')
  call s:check('go', ['go', 'version'], '^go version go\(\d\+\.\d\+\.\d\+\)')

  call health#report_start('my: Additional Commands')
  call s:check('bat', ['bat', '--version'], '^bat \(\d\+\.\d\+\.\d\+\)')
  call s:check('exa', ['exa', '--version'], '^exa v\(\d\+\.\d\+\.\d\+\)')
  call s:check('procs', ['procs', '--version'], '^procs \(\d\+\.\d\+\.\d\+\)')
  call s:check('fd', ['fd', '--version'], '^fd \(\d\+\.\d\+\.\d\+\)')
  call s:check('tidy', ['tidy', '--version'], '^HTML Tidy for .\+ version \(\d\+\.\d\+\.\d\+\)')


  call health#report_start('my: Python Modules')
  call s:check('flake8', ['python3', '-m', 'flake8', '--version'], '^\(\d\+\.\d\+\.\d\+\)')
  call s:check('mypy', ['python3', '-m', 'mypy', '--version'], '^mypy \(\d\+\.\d\+\)')
  call s:check('autopep8', ['python3', '-m', 'autopep8', '--version'], '^autopep8 \(\d\+\.\d\+\.\d\+\)')
  call s:check('isort', ['python3', '-m', 'isort', '--version'], 'VERSION \(\d\+\.\d\+\.\d\+\)')

  call health#report_start('my: SKK-JISHO')
  let jisyo_path = '/usr/local/share/skk/SKK-JISYO.L'
  call s:checkfile(jisyo_path)
endfunction
