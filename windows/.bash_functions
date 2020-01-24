echo '.bash_functions'

function pinst()
{
    pacman -S "mingw-w64-i686-$1"
}
function puninst()
{
    pacman -Rs "mingw-w64-i686-$1"
}

function color()
{
  for fore in `seq 30 37`
  do printf "\e[${fore}m \\\e[${fore}m \e[m\n"
    for mode in 1 4 5
    do printf "\e[${fore};${mode}m \\\e[${fore};${mode}m \e[m"
      for back in `seq 40 47`
      do printf "\e[${fore};${back};${mode}m \\\e[${fore};${back};${mode}m \e[m"
      done
      echo
    done
    echo
  done
  printf " \\\e[m\n"
}

