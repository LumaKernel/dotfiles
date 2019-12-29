
scoop install 7zip git --global
scoop bucket add extras
scoop install ag
scoop install extras/googlechrome
scoop install msys2

scoop install vim
scoop install wsl-terminal
scoop install python

cd ~
git clone https://github.com/LumaKernel/dotfiles ~/dotfiles

ln.ps1 -s ~/dotfiles/.vimrc ~/.vimrc
ln.ps1 -s ~/dotfiles/.mintty ~/.minttyrc

msys2

