
echo "from install-win-after-sudo.ps1"

scoop install 7zip git --global
scoop bucket add extras

scoop install extras/googlechrome --global
scoop install msys2
msys2 -mintty

# scoop install ag --global
scoop install bat
scoop install fzf


scoop install vim
scoop install neovim
scoop install wsl-terminal
scoop install python36
# scoop install llvm

# -- git の設定
git config --global core.ignorecase false
git config --global core.quotepath false
git config --global core.safecrlf true
git config --global core.autocrlf false


cd ~
git clone https://github.com/LumaKernel/dotfiles ~/dotfiles

~/dotfiles/windows/symlinks.ps1

scoop install concfg
scoop install pshazz

concfg import ~/dotifles/windows/concfg/lumc-vs-code-dark-plus.json -n


# install dein.vim
git clone https://github.com/Shougo/dein.vim ~/.cache/dein/repos/github.com/Shougo/dein.vim

echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"

