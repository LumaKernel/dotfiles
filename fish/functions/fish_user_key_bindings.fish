function fish_user_key_bindings
  fish_default_key_bindings

  if functions fzf_key_bindings >/dev/null
    fzf_key_bindings
  end

  bind \cd delete-char
  bind -M insert \cd delete-char
  bind -M visual \cd delete-char
  bind \t complete_if_non_empty
  bind -M insert \t complete_if_non_empty
  bind -M visual \t complete_if_non_empty
end
