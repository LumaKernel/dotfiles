
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

scoop install sudo

iwr -useb get.scoop.sh | iex
if (-not(([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"`
    ))) {
    if ( $env:EXIT_NOT_ADMIN ) {
      exit
    }
    sudo Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/LumaKernel/dotfiles/master/install-win-after-sudo.ps1')
} else {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/LumaKernel/dotfiles/master/install-win-after-sudo.ps1')
}

