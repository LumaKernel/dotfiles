# AtCoder version of Rust
function atcargo_watch_x --wraps cargo
  cargo watch -s "rustup run 1.42.0 --install cargo $argv"
end
