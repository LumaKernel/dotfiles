
" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")

nnoremap <Leader>; :VimShowHlGroup<CR>
nnoremap <Leader>: :VimShowHlItem<CR>

call add(g:mapping_descriptions, ['<Leader>;', ':VimShowHlGroup'])
call add(g:mapping_descriptions, ['<Leader>:', ':VimShowHlItem'])

function! PutInNew(cmd) abort
  let l:res = execute(a:cmd)
  new
    setlocal buftype=nofile

  put =l:res
endfunction

function! s:PutLineInNew()
  let l:linenr = line('.')
  let l:line = get(getbufline('%', l:linenr), 0, '')

  call PutInNew(l:line)
  call histadd(':', "call PutInNew('" .. substitute(l:line, "'", "''", 'g') .. "')")
endfunction

command! -nargs=* PutInNew :call PutInNew(<q-args>)
command! PutLineInNew :call <SID>PutLineInNew()


function! s:_CopyAndPutLine(add_verbose) abort
  let l:linenr = line('.')
  let l:line = get(getbufline('%', l:linenr), 0, '')

  function! s:_AfterQuitCmdwin_CopyAndPutLine() abort closure
    if a:add_verbose
      let l:line = 'verbose ' .. l:line
    endif

    call PutInNew(l:line)
    call histadd(':', "call PutInNew('" .. substitute(l:line, "'", "''", 'g') .. "')")
  endfunction

  au init_vim BufEnter * ++once call <SID>_AfterQuitCmdwin_CopyAndPutLine()
  quit

endfunction

function! s:_InsertVerboseInThisLine()
  let l:linenr = line('.')
  let l:line = get(getbufline('%', l:linenr), 0, '')
  let l:line = 'verbose ' .. l:line
  call setbufline('%', l:linenr, [l:line])
endfunction

function! s:RunLines(add_verbose, type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  let l:lines = @@

  let &selection = sel_save
  let @@ = reg_save

  function! s:_AfterQuitCmdwin_RunLines() abort closure
    if a:add_verbose
      let l:lines = 'verbose ' .. l:lines
    endif

    exe l:lines

    for l:cmd in split(l:lines, "\n")
      call histadd(':', l:cmd)
    endfor

  endfunction

  au init_vim BufEnter * ++once call <SID>_AfterQuitCmdwin_RunLines()
  quit
endfunction


function! s:RunLines0(...) abort
  call call('s:RunLines', [0] + a:000)
endfunction

function! s:RunLines1(...) abort
  call call('s:RunLines', [1] + a:000)
endfunction


function! s:MyCmdwinSetting() abort
  inoremap <buffer> <C-CR> <ESC>:call <SID>_CopyAndPutLine(0)<CR>
  nnoremap <buffer> <C-CR> :call <SID>_CopyAndPutLine(0)<CR>

  inoremap <buffer> <C-S-CR> <ESC>:call <SID>_CopyAndPutLine(1)<CR>
  nnoremap <buffer> <C-S-CR> :call <SID>_CopyAndPutLine(1)<CR>

  inoremap <buffer><silent> <S-CR> <ESC>:call <SID>_InsertVerboseInThisLine()<CR><CR>
  nnoremap <buffer><silent> <S-CR> :call <SID>_InsertVerboseInThisLine()<CR><CR>

  " nmap <buffer><silent> <CR> :set opfunc=<SID>RunLines0<CR>ga@
  vmap <buffer> <CR> :<C-U>call <SID>RunLines0(visualmode(), 1)<CR>

  " nmap <buffer><silent> <S-CR> :set opfunc=<SID>RunLines1<CR>ga@
  vmap <buffer> <S-CR> :<C-U>call <SID>RunLines1(visualmode(), 1)<CR>

  inoremap <buffer><silent> <CR>
        \ <C-o>:let b:reg_save=@@<CR>
        \<C-o>y$
        \<C-o>:let b:rest=@@<CR>
        \<C-o>d$
        \<ESC>:put =b:rest<CR>
        \:let @@=b:reg_save<CR>
        \0i
endfunction


au CmdwinEnter : :call <SID>MyCmdwinSetting()


" debug

finish

command! MES :new | set buftype=nofile | :put =execute('mes') | :only
command! M :new | set buftype=nofile | :put =g:mymes | :only
command! MC :let g:mymes=[]

