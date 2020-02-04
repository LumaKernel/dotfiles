function colortable256
  for fgbg in 38 48
    for color in (seq 0 255)
      printf "\e["$fgbg";5;%sm  %3s  \e[0m" $color $color
      if [ (math "($color + 1) % 6") = 4 ]
        echo
      end
    end
    echo
  end
end
