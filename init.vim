set encoding=utf-8
scriptencoding utf-8

if v:version < 802 && !has('nvim')
  echomsg "Version of vim is old. Update your vim."
  finish
endif

" コメント方針 : 適当に書く．日本語で書く．
"   理解したものは消す
"   :help を見よう

augroup init_vim | au! | augroup END

let g:from_pwsh = 0
let g:is_wsl = 0
silent! let g:from_pwsh = !has('nvim') && $RunFromPowershell ==# '1'
silent! let g:is_wsl = has('unix') && system('uname -a') =~? 'microsoft'

source ~/dotfiles/vim/option-basic.vim
source ~/dotfiles/vim/mapping.vim
source ~/dotfiles/vim/dein-setting.vim
source ~/dotfiles/vim/openapps.vim
source ~/dotfiles/vim/colors.vim


source ~/dotfiles/vim/gvim.vim

source ~/dotfiles/vim/setup-powershell.vim

source ~/dotfiles/vim/cpp.vim

source ~/dotfiles/vim/vimscript.vim


if !g:from_pwsh
  let g:switch_color_scheme_default = 'onedark'
  augroup init-vim
    autocmd VimEnter * ++once ++nested LoadColorScheme
  augroup END
endif

function! CoqSwitchStyle() abort
  if !exists('b:coquilleIDE') || b:coquilleIDE.dead()
    return
  endif

  let b:coquilleIDE.my_style = !get(b:coquilleIDE, 'my_style', 0)
  if b:coquilleIDE.my_style
    let b:coquilleIDE.style_checked = 'last_line'
    let b:coquilleIDE.style_queued  = 'last_line'
  else
    let b:coquilleIDE.style_checked = 'all'
    let b:coquilleIDE.style_queued  = 'all'
  endif
  CoqRecolor
endfunction
command! CoqSwitchStyle call CoqSwitchStyle()
