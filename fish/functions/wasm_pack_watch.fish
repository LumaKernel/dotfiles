function wasm_pack_watch
  set -l ARGS
  if test (count $argv) = 0
    set ARGS "build"
  else
    set ARGS $argv
  end
  watchexec -e rs -r -w src -w Cargo.toml -w Cargo.lock --clear -- wasm-pack $ARGS
end
