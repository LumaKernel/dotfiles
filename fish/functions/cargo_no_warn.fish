function cargo_no_warn --wraps=cargo --description='Run cargo with warnings disabled'
  RUSTFLAGS=$RUSTFLAGS" -Awarnings" cargo $argv
end
