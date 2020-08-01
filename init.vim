set encoding=utf-8
scriptencoding utf-8

" コメント方針 : 適当に書く．日本語で書く．

augroup init_vim
  autocmd!
augroup END

let g:from_pwsh = 0
let g:is_wsl = 0
silent! let g:from_pwsh = !has('nvim') && $RunFromPowershell ==# '1'
silent! let g:is_wsl =
      \ has('unix')
      \ && system('uname -r') =~? 'microsoft'

source ~/dotfiles/vim/option-basic.vim
source ~/dotfiles/vim/mapping.vim

if (v:version < 802 && !has('nvim')) || (v:version < 800 && has('nvim'))
  augroup init-vim
    autocmd VimEnter * echomsg "Version of vim is old. Update your vim."
  augroup END
  finish
endif

source ~/dotfiles/vim/nvim.vim
source ~/dotfiles/vim/dein-setting.vim

source ~/dotfiles/vim/gvim.vim
source ~/dotfiles/vim/setup-powershell.vim

if !g:from_pwsh
  augroup init-vim
    autocmd VimEnter * ++once ++nested
        \ if exists(':LoadColorScheme')
        \ |  LoadColorScheme
        \ | endif
  augroup END
endif
