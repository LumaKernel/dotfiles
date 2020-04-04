function fish_user_key_bindings
  fzf_key_bindings

  bind \cd delete-char
  bind -M insert \cd delete-char
  bind -M visual \cd delete-char
end
