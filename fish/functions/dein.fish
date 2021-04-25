function dein
  set where (find ~/.cache/dein/nvim/repos/ -mindepth 3 -maxdepth 3 -type d | fzf --reverse)
  if [ -n "$where" ]
    cd "$where"
  end
end
