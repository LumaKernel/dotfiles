
Param([switch]$f, [switch]$force)

$force = $f.IsPresent -or $force.IsPresent

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
  iex "sudo $PsCommandPath $(if ($force) {"-force"})"
  exit $?
}

$files = @(
  @{target="init.vim"; path=""; name=".vimrc"},
  @{target="init.vim"; path="AppData/Local/nvim"},
  @{target="ginit.vim"; path="AppData/Local/nvim"},
  ".minttyrc",
  ".bash_profile",
  ".bashrc",
  ".bash_aliases",
  ".bash_functions",
  @{target="Microsoft.PowerShell_profile.ps1"; path="Documents/WindowsPowerShell"},
"")

foreach ($file in $files) {
  if($file.GetType() -eq [string]) {
    if($file -eq "") { continue }

    $file = @{target=$file; path=""}
  }

  if (-not $file.ContainsKey("name")) { $file.name = $file.target }
  $file.target = "~/dotfiles/" + $file.target
  if ($file.path -eq "") { $file.path = "~" }
  else { $file.path = "~/" + $file.path }

  if (-not (Test-Path $file.path)) {
    mkdir $file.path
  }
  
  echo ""
  echo "now: $($file.path + "/" + $file.name)"
  if (Test-Path ($file.path + "/" + $file.name)) {
    echo "already exists"
    if($force) {
      echo "deleting"
      rm ($file.path + "/" + $file.name)
    } else {
      continue
    }
  }

  if (-not (Test-Path ($file.path + "/" + $file.name))) {
    echo "making symbolic link"
    New-Item -ItemType SymbolicLink @file | Out-Null
    if (-not $?) { echo "failed1" }
  }
}

