set encoding=utf-8
scriptencoding utf-8

" コメント方針 : 適当に書く．日本語で書く．

augroup init_vim
  autocmd!
augroup END

if executable('/usr/bin/whoami') && system('/usr/bin/whoami') =~# '^root\(\n\|$\)'
  finish
endif

function! IsPrivateMode() abort
  return $PRIVATE_MODE == '1'
endfunction

" "ddc" | "coc" | "none"
let g:complete_mode = "coc"
if !empty($VIM_COMPLETE_MODE)
  let g:complete_mode = $VIM_COMPLETE_MODE
endif

" "vim-lsp" | "coc" | "none"
let g:lsp_mode = "coc"
if !empty($VIM_LSP_MODE)
  let g:lsp_mode = $VIM_LSP_MODE
endif

" "tsu" | "lsp" | "none"
let g:ts_lsp_mode = "none"
if !empty($VIM_TS_LSP_MODE)
  let g:ts_lsp_mode = $VIM_TS_LSP_MODE
endif


if g:complete_mode isnot# "coc" && g:lsp_mode is# "coc"
  let g:lsp_mode = "none"
endif

if g:lsp_mode is# "none"
  \ || g:complete_mode is# "none"
  let g:ts_lsp_mode = "none"
endif

if g:complete_mode is# "coc"
  let g:ts_lsp_mode = "lsp"
endif


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
