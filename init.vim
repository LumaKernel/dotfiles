set encoding=utf-8
scriptencoding utf-8

" コメント方針 : 適当に書く．日本語で書く．
"   ぶっちゃけ理解したものは消す
"   :help を，見ろ

augroup init_vim | au! | augroup END

let g:from_pwsh = !has('nvim') && $RunFromPowershell ==# '1'

let g:mapping_descriptions = []

source ~/dotfiles/vimfiles/option-basic.vim
source ~/dotfiles/vimfiles/mapping.vim
source ~/dotfiles/vimfiles/dein-setting.vim
source ~/dotfiles/vimfiles/show-whitespace.vim
source ~/dotfiles/vimfiles/openapps.vim
source ~/dotfiles/vimfiles/colors.vim

source ~/dotfiles/vimfiles/gvim.vim

source ~/dotfiles/vimfiles/setup-powershell.vim

source ~/dotfiles/vimfiles/cpp.vim
source ~/dotfiles/vimfiles/competitive-programming.vim

source ~/dotfiles/vimfiles/vimscript.vim


