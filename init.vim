set encoding=utf-8
scriptencoding utf-8

" コメント方針 : 適当に書く．日本語で書く．
"   ぶっちゃけ理解したものは消す
"   :help を，見ろ

augroup init_vim | au! | augroup END

let g:from_pwsh = !has('nvim') && $RunFromPowershell ==# '1'

let g:mapping_descriptions = []

source ~/dotfiles/vim/option-basic.vim
source ~/dotfiles/vim/mapping.vim
source ~/dotfiles/vim/dein-setting.vim
source ~/dotfiles/vim/show-whitespace.vim
source ~/dotfiles/vim/openapps.vim
source ~/dotfiles/vim/colors.vim

source ~/dotfiles/vim/gvim.vim

source ~/dotfiles/vim/setup-powershell.vim

source ~/dotfiles/vim/cpp.vim
source ~/dotfiles/vim/competitive-programming.vim

source ~/dotfiles/vim/vimscript.vim


if !g:from_pwsh
  colorscheme iceberg
endif

