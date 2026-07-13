function git_switch_default
  git switch (git symbolic-ref refs/remotes/origin/HEAD --short | sed 's|origin/||')
end
