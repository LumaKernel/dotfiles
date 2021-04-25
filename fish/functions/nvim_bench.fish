function nvim_bench
  nvim +"call dein#recache_runtimepath()" +qa!
  and nvim +":UpdateRemotePlugins" +qa!
  begin
    set -l sum 0
    set -l T 10
    for i in (seq 1 $T)
      /bin/rm -f /tmp/nvim-startuptime
      nvim +"autocmd VimEnter * qa!" --startuptime /tmp/nvim-startuptime
      set -l this (cat /tmp/nvim-startuptime | tail -n 1 | awk '{print $1}')
      echo $i: $this ms
      set sum (math -- $sum + $this)
      /bin/rm -f /tmp/nvim-startuptime
    end
    echo Mean Time: (math -- $sum / $T) ms
  end
end
