
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install sudo
sudo scoop install 7zip git --global
scoop bucket add extras
scoop install ag
scoop install extras/googlechrome
scoop install msys2
start msys2

scoop install vim
scoop install wsl-terminal
scoop install python

cd ~
git clone https://github.com/LumaKernel/bootstrap


