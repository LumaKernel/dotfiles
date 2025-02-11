function cargo_watch_no_warn_check --wraps='cargo watch -x check' --description='Run cargo watch check with warnings disabled'
  RUSTFLAGS=-Awarnings cargo_watch -x check
end
