function cargo_watch --wraps='cargo watch'
  cargo watch --ignore 'target/*' --ignore '**/*.snap.new' $argv
end
