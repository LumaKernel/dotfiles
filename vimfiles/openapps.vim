
scriptencoding utf-8

" Vim と explorer, Finder, terminal への橋渡し
" 正直微妙だと思う．基本的に，すべて Vim 上で行えるか，
" ターミナルでやるのが理想 ?

if has('mac')
  nnoremap <silent> <Leader>exp :!open .<CR>
  nnoremap <silent> <Leader>cmd :!open -a Terminal.app .<CR>

  call add(g:mapping_descriptions, ['<Leader>exp', 'open Finder'])
  call add(g:mapping_descriptions, ['<Leader>cmd', 'open Terminal'])
elseif has('win32') || has('win64')
  if has('gui') || has('nvim')
    nnoremap <unique><silent> <expr> <Leader>exp ":silent !start explorer .\<CR>"
    nnoremap <unique><silent> <Leader>cmd :silent !start cmd<CR>
    nnoremap <unique><silent> <Leader>pws :silent !start powershell<CR>
    nnoremap <unique><silent> <expr> <Leader>ubu ":silent !start " .. $LocalAppData .. "\\wsltty\\bin\\mintty.exe --WSL=\"Ubuntu\" --configdir=\"" .. $AppData .. "\\wsltty\"\<CR>"
    call add(g:mapping_descriptions, ['<Leader>exp', 'open explorer'])
    call add(g:mapping_descriptions, ['<Leader>cmd', 'open cmd'])
    call add(g:mapping_descriptions, ['<Leader>pws', 'open powershell'])

    let s:msys_exe = 'msys2'
    if executable(s:msys_exe)
      let s:to_unset = ['VIM', 'VIMRUNTIME', 'MYVIMRC', 'MYGVIMRC']
      let s:env_unset = join(map(s:to_unset, '"set \"" .. v:val .. "=\" && "'), '')
      let g:msys_run_cmd = ':silent !start cmd /k ' .. s:env_unset .. s:msys_exe .. ' -where . -full-path -mingw64 -mintty -no-start && exit' .. "\<CR>"
      nnoremap <silent> <expr> <Leader>bas g:msys_run_cmd

      call add(g:mapping_descriptions, ['<Leader>bas', 'open msys2'])
    endif
  endif
elseif has('unix')
  " --working-directory=は必要なし
  nnoremap <silent> <Leader>exp :!xdg-open .<CR>
  nnoremap <silent> <Leader>cmd :!gnome-terminal<CR>
  call add(g:mapping_descriptions, ['<Leader>exp', 'xdg-open'])
  call add(g:mapping_descriptions, ['<Leader>cmd', 'open gnome-terminal'])
endif

