function nvim_bench
  set -l NVIM_RUN nvim
  if test -n $argv[1]
    set NVIM_RUN $argv[1]
  end
  eval $NVIM_RUN' +"call dein#recache_runtimepath()" +qa!'
  and eval $NVIM_RUN' +":UpdateRemotePlugins" +qa!'
  begin
    set -l sum 0
    set -l T 10
    for i in (seq 1 $T)
      /bin/rm -f /tmp/nvim-startuptime
      eval $NVIM_RUN' +"autocmd VimEnter * ++nested qa!" --startuptime /tmp/nvim-startuptime'
      set -l this (cat /tmp/nvim-startuptime | tail -n 1 | awk '{print $1}')
      echo $i: $this ms
      set sum (math -- $sum + $this)
      /bin/rm -f /tmp/nvim-startuptime
    end
    echo Mean Time: (math -- $sum / $T) ms
  end
end
