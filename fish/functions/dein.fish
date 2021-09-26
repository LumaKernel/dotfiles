function dein
  set where (find ~/.cache/dein -mindepth 5 -maxdepth 5 -type d | fzf --reverse)
  if [ -n "$where" ]
    cd "$where"
  end
end
