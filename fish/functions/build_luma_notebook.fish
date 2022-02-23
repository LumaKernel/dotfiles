function build_luma_notebook
  if ! _luma_power_check
    return 1
  end

  set DO_PUSH 0
  if test "$argv[1]" = '--push'
    set DO_PUSH 1
    echo "push mode is on"
  else
    echo "push mode is off"
  end
  if ! test -d "$HOME/luma-jupyter"
    echo "~/luma-jupyter not found. Cloning..."
    git clone https://github.com/LumaKernel/luma-jupyter "$HOME/luma-jupyter"
  end
  cd "$HOME/luma-jupyter"
  docker pull lumakernel/luma-notebook
  make build/luma-notebook
end
