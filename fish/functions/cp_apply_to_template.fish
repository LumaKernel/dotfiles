function cp_apply_to_template
  set -l TEMP_DIR "$HOME/ghq/github.com/LumaKernel/cp-rust-template"
  set -l PATHS_WATCH "src/luma" "src/luma.rs" ".vscode" ".gitignore" ".ignore"
  # pushd
  #   git diff --
  # popd
  for p in $PATHS_WATCH
    mv "$TEMP_DIR/$p" "$TEMP_DIR/$p.bak"
    cp -r "./$p" "$TEMP_DIR/$p"
  end
end
