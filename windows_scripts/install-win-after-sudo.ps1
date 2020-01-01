
echo "from install-win-after-sudo.ps1"

scoop install 7zip git --global
scoop bucket add extras
scoop install ag
scoop install extras/googlechrome --global
scoop install msys2
msys2 -mintty

scoop install vim
scoop install neovim
scoop install wsl-terminal
scoop install python36

cd ~
git clone https://github.com/LumaKernel/dotfiles ~/dotfiles


~/dotfiles/windows_scripts/symlinks.ps1

