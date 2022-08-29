# AtCoder version of Rust
function atcargo_watch_check --wraps 'cargo check'
  RUSTFLAGS=-Awarnings cargo watch -s "rustup run 1.42.0 --install cargo check --target-dir cp.target"
end
