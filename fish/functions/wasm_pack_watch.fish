function wasm_pack_watch
  set -l ARGS
  if test (count $argv) = 0
    set ARGS "build"
  else
    set ARGS $argv
  end
  cargo watch -i "pkg/*" -i "*.{html,ts,js,tsx,svelte,vue,css,scss,sass,less}" -s "wasm-pack $ARGS"
end
