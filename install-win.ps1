
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
iwr -useb get.scoop.sh | iex

scoop install sudo

echo hello from not sudo
sudo echo hello from sudo

# sudo Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/LumaKernel/dotfiles/master/install-win-after-sudo.ps1')

