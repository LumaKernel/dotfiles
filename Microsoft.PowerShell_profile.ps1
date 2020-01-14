$env:RunFromPowershell = 1

$env_to_del =
  "VIM",
  "VIMRUNTIME",
  "MYVIMRC",
  "MYGVIMRC"

foreach ($var in $env_to_del) {
  Remove-Item env:$var -ErrorAction SilentlyContinue
}

Set-Alias checkvers ~/scoop/apps/scoop/current/bin/checkver.ps1

[console]::BufferHeight = [math]::Max(3000, [console]::BufferHeight)
