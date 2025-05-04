function cargo_watch_install --wraps='watchexec' --description 'Install cargo plugins with watchexec'
  watchexec -e rs -r -w src -w Cargo.toml -w Cargo.lock --clear -- cargo install --path . --locked $argv
end
