function cargo_watch_install --wraps='cargo watch'
  cargo_watch -s 'cargo install --path . --locked'
end
