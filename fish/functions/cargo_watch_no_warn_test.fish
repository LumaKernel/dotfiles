function cargo_watch_no_warn_test --wraps='cargo watch -x test' --description='Run cargo watch test with warnings disabled'
  CARGO_TARGET_DIR=cargo_watch_no_warn_test.__luma_rust_target \
    RUST_BACKTRACE=1 \
    RUSTFLAGS=-Awarnings \
    cargo watch --ignore 'target/*' --ignore '*.__luma_rust_target/*' -x test
end
