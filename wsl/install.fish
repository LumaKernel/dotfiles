
if [ (whoami) != "root" ]
  echo "sudo fish ~/wsl/install.fish"
  exit 1
end

fisher add joehillen/to-fish

