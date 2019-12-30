
Param([switch]$f, [switch]$force)


if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
  $params = $PsBoundParameters
  sudo iex -Command "$PSCommandPath @args @params"
  exit
}

$dotfiles = @(
  ".vimrc",
  ".minttyrc",
  ".bash_profile",
  ".bashrc",
  ".bash_aliases",
  ".bash_functions",
"")

foreach($file in $dotfiles) {
  if($file -eq "") { continue }
  if(Test-Path ("${env:UserProfile}/" + $file)) {
    rm ("${env:UserProfile}/" + $file)
  }
  ln.ps1 -s ("${env:UserProfile}/dotfiles/" + $file) ("${env:UserProfile}/" + $file)
}

