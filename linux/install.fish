
if [ (whoami) = "root" ]
  echo "[Error] Do NOT run with sudo."
  exit 1
end

fisher add joehillen/to-fish
# fisher add jorgebucaran/fish-nvm
fisher add otms61/fish-pet
fisher add LumaKernel/fish-gulp-complete
fisher add LumaKernel/fish-fd-complete@main
