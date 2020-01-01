
scriptencoding utf-8

" Vim と explorer, Finder, terminal への橋渡し
" 正直微妙だと思う．基本的に，すべて Vim 上で行えるか，
" ターミナルでやるのが理想 ?

if has('mac')
  nnoremap <silent> <Leader>u :!open .<CR>
  nnoremap <silent> <Leader>o :!open -a Terminal.app .<CR>
elseif has('win32') || has('win64')
  if has('gui')
    nnoremap <silent> <expr> <Leader>u ":silent !start explorer .\<CR>"
    nnoremap <silent> <Leader>o :silent !start cmd<CR>
    nnoremap <silent> <expr> <Leader>i ":silent !start " .. $LocalAppData .. "\\wsltty\\bin\\mintty.exe --WSL=\"Ubuntu\" --configdir=\"" .. $AppData .. "\\wsltty\"\<CR>"

    let s:msys_path = expand('~/scoop/apps/msys2/current/msys2_shell.cmd')
    if executable(s:msys_path)
      let s:to_reset = ['VIM', 'VIMRUNTIME', 'MYVIMRC', 'MYGVIMRC']
      let s:env_reset = join(map(s:to_reset, '"set \"" .. v:val .. "=\" && "'), '')
      let g:msys_run_cmd = ':silent !start cmd /k ' .. s:env_reset .. s:msys_path .. ' -where . -full-path -mingw64 -mintty -no-start && exit' .. "\<CR>"
      nnoremap <silent> <expr> <Leader>b g:msys_run_cmd
    endif
  endif
elseif has('unix')
  " --working-directory=は必要なし
  nnoremap <silent> <Leader>u :!xdg-open .<CR>
  nnoremap <silent> <Leader>o :!gnome-terminal<CR>
endif

