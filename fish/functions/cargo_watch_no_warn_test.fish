function cargo_watch_no_warn_test --wraps='cargo watch -x test' --description='Run cargo watch test with warnings disabled'
  RUSTFLAGS=-Awarnings cargo_watch -x test
end
