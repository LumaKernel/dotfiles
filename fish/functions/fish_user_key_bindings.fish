function fish_user_key_bindings
  fzf_key_bindings

  bind --preset \cd delete-char
  bind --preset -M insert \cd delete-char
  bind --preset -M visual \cd delete-char
end
