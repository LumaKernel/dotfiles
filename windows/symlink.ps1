
Param([switch]$f, [switch]$force)

$force = $f.IsPresent -or $force.IsPresent

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
  iex "sudo $PsCommandPath $(if ($force) {"-force"})"
  exit $?
}


$files = @(
  @{ target="init.vim"; path=""; name=".vimrc" }
  @{ target="init.vim"; path="AppData/Local/nvim" }
  @{ target="ginit.vim"; path="AppData/Local/nvim" }
  @{ target="windows/wsltty-config"; fullpath="$env:AppData/wsltty/config" }
  "windows/.minttyrc"
  "windows/.bash_profile"
  "windows/.bashrc"
)

if( (gcm pwsh -ea 0) -and (pwsh -NoProfile -Command "`$profile")) {
  $files += @(@{target="windows/profile.ps1"; fullpath=@($(pwsh -NoProfile -Command "`$profile"))[0]})
}

if( (gcm powershell -ea 0) -and (powershell -NoProfile -Command "`$profile")) {
  $files += @(@{target="windows/profile.ps1"; fullpath=@($(powershell -NoProfile -Command "`$profile"))[0]})
}

# -- pshazz

$files = & {
  $configHome = $env:XDG_CONFIG_HOME, "$env:USERPROFILE\.config" | Select-Object -First 1
  $pshazzConfig = "$configHome\pshazz"

  $files + @(
    @{target="windows/pshazz"; fullpath=$pshazzConfig}
  )
}


foreach ($file in $files) {
  if($file.GetType() -eq [string]) {
    if(!$file) { continue }

    $file = @{target=$file; path=""}
  }

  $target_name = Split-Path $file.target -Leaf
  $file.target = "~/dotfiles/" + $file.target

  if ( !$file.path ) { $file.path = "~" }
  else { $file.path = (Resolve-Path ("~/" + $file.path)).Path }

  if ($file.fullpath) {
    $file.path = Split-Path $file.fullpath
    $name = Split-Path $file.fullpath -Leaf
    if ($name) {
      $file.name = $name
    }
    $file.Remove("fullpath")
  }

  if (!$file.ContainsKey("name")) { $file.name = $target_name }

  if (!(Test-Path $file.path)) {
    mkdir $file.path
  }
  
  echo ""
  echo "now: $($file.path + "/" + $file.name)"
  if (Test-Path ($file.path + "/" + $file.name)) {
    echo "already exists"
    if($force) {
      echo "deleting"
      (Get-Item ($file.path + "/" + $file.name)).Delete()
    } else {
      continue
    }
  }

  if (!(Test-Path ($file.path + "/" + $file.name))) {
    echo "making symbolic link"

    if (!(Test-Path ($file.path))) {
      mkdir ($file.path)
    }

    New-Item -ItemType SymbolicLink @file | Out-Null
    if (!$?) { echo "failed" }
  }
}

