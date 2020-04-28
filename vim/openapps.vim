
scriptencoding utf-8

" Vim と explorer, Finder, terminal への橋渡し
" 正直微妙だと思う．基本的に，すべて Vim 上で行えるか，
" ターミナルでやるのが理想 ?

if has('mac')
  nnoremap <silent> <Leader>exp :!open .<CR>
  nnoremap <silent> <Leader>sh :!open -a Terminal.app .<CR>

elseif has('win32') || has('win64')
  if has('gui') || has('nvim')
    let s:to_unset = ['VIM', 'VIMRUNTIME', 'MYVIMRC', 'MYGVIMRC']
    let s:env_unset = join(map(s:to_unset, '"set \"" .. v:val .. "=\""'), ' && ')

    nnoremap <silent> <Leader>exp :silent !start explorer .<CR>
    exe 'nnoremap <silent> <Leader>cmd :silent !start ' .. s:env_unset .. "\<CR>"
    if executable('pwsh')
      nnoremap <silent> <Leader>sh :silent !start pwsh<CR>
    elseif executable('powershell')
      nnoremap <silent> <Leader>sh :silent !start powershell<CR>
    endif
    nnoremap <silent><expr> <Leader>ubu ":silent !start " .. $LocalAppData .. "\\wsltty\\bin\\mintty.exe --WSL=\"Ubuntu\" --configdir=\"" .. $AppData .. "\\wsltty\"\<CR>"

    if executable('msys2')
      nnoremap <silent> <Leader>bas :silent !msys2 -here -full-path -mingw64 -mintty -no-start<CR>

    endif
  endif
elseif has('unix')
  " --working-directory=は必要なし
  nnoremap <silent> <Leader>exp :!xdg-open .<CR>
  nnoremap <silent> <Leader>sh :!gnome-terminal<CR>
endif


" -- ターミナル

if has('terminal') || has('nvim')
  if has('win32') || has('win64') || g:is_wsl
    if executable('pwsh.exe') && !g:is_wsl
      " WSL で pwsh.exe を起動するとなぜか $PWD がセットされない
      command! Pwsh :vertical new | :term pwsh.exe
    elseif executable('powershell.exe')
      command! Pwsh :vertical new | :term powershell.exe
    endif
  endif
endif
