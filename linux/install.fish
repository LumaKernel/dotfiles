
if [ (whoami) == "root" ]
  echo "[Error] Do NOT run with sudo."
  exit 1
end

fisher add joehillen/to-fish

