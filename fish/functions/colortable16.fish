function colortable16
  for clbg in (seq 40 47) (seq 100 107) 49
    for clfg in (seq 30 37) (seq 90 97) 39
      for attr in 0 1 2 4 5 7
        echo -en "\e[$attr;$clbg;"$clfg"m ^[$attr;$clbg;$clfg""m \e[0m"
      end
      echo
    end
  end
end
