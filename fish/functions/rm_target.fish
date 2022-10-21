function rm_target
  if test -f Cargo.toml
    /bin/rm -rf ./target
  else
    echo "[ERROR] Cargo.toml file not found."
    return 1
  end
end
