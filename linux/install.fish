
if [ (whoami) = "root" ]
  echo "[Error] Do NOT run with sudo."
  exit 1
end

fisher install joehillen/to-fish
# fisher install jorgebucaran/fish-nvm
fisher install otms61/fish-pet
fisher install LumaKernel/fish-gulp-complete
fisher install LumaKernel/fish-fd-complete@main
