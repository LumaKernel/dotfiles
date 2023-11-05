function cargo_watch_error --wraps='cargo watch -x check' --description='Run cargo watch check with warnings disabled'
  RUSTFLAGS=-Awarnings cargo watch -x check
end
