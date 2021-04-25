function g
  if set -l REPO (ghq list | fzf)
    cd (ghq root)"/$REPO"
  end
end
