function cargo_clippy_nameonly
  cargo clippy --no-deps 2>&1 | grep ' --> src/' | string replace -r '\d+:\d+$' '' | uniq
end
