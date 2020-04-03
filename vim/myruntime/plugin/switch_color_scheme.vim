" color scheme 設定永続化

let s:save_file = expand('~/.vim-color-schme')

function! s:load_color_scheme() abort
  let name = get(g:, 'switch_color_scheme_default', 0)
  if filereadable(s:save_file)
    let file = readfile(s:save_file)
    if len(file) >= 1 && len(file) <= 2 && get(file, 1, '') ==# ''
      let name = file[0]
    endif
  endif
  if !empty(name) && type(name) == v:t_string
    try
      execute 'colorscheme' name
    catch
      echohl Error
      echomsg printf('[switch_color_scheme.vim] "%s" not found.', name)
      echohl None
      return
    endtry
  endif
endfunction

function! s:switch_color_scheme(name) abort
  let name = a:name
  try
    execute 'colorscheme' name
  catch
    echohl Error
    echomsg printf('[switch_color_scheme.vim] "%s" not found.', name)
    echohl None
    return
  endtry
  if (!filereadable(s:save_file) || filewritable(s:save_file)) && !isdirectory(s:save_file)
    call writefile([name], s:save_file)
  else
    echohl Error
    echomsg printf('[switch_color_scheme.vim] "%s" cannot use for writing.', s:save_file)
    echomsg printf('[switch_color_scheme.vim] %s', string({
          \   'filereadable': filereadable(s:save_file),
          \   'filewritable': filewritable(s:save_file),
          \   'isdirectory': isdirectory(s:save_file),
          \ }))
    echohl None
    return
  endif
endfunction

command! -bar -nargs=* SwitchColorScheme call <SID>switch_color_scheme(<q-args>)
command! -bar LoadColorScheme call <SID>load_color_scheme()
