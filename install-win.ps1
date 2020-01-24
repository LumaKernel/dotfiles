
echo "install-win.ps1"

Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install sudo

sudo Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/LumaKernel/dotfiles/master/windows/install-win-after-sudo.ps1')

