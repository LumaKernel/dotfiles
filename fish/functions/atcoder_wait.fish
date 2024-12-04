function atcoder_wait
  set -l contest $argv[1]
  while not cargo compete new $contest
    echo $contest': still... wait 10 seconds...'
    sleep 10
  end
    and cd $contest
    and cargo build
end
