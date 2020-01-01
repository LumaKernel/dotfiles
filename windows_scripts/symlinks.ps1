
Param([switch]$f, [switch]$force)

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
  sudo iex "$PsCommandPath @Args @PsBoundParameters"
  exit
}

$force = $f -or $force

$files = @(
  @{target="init.vim"; path=""; name=".vimrc"},
  @{target="init.vim"; path="AppData/Local/nvim"},
  @{target="ginit.vim"; path="AppData/Local/nvim"},
  ".minttyrc",
  ".bash_profile",
  ".bashrc",
  ".bash_aliases",
  ".bash_functions",
"")

foreach($file in $files) {
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

  if (-not (Test-Path ($file.path + "/" + $file.name)) -or $force) {
    if($force) {
      rm ($file.path + "/" + $file.name)
    }
    New-Item -ItemType SymbolicLink @file
  } else {
    echo "already exists: $($file.path + "/" + $file.name)"
  }
}

