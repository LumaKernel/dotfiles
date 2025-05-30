function npm --wraps=npm
  set -l with_time 1
  if contains -- --version $argv
      or contains -- -v $argv
    set with_time 0
  end
  if test $with_time -eq 1
    time command npm $argv
  else
    command npm $argv
  end
end
