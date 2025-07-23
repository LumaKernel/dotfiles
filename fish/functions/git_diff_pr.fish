function git_diff_pr --wraps='git diff'
  git diff (git merge-base main HEAD) $argv
end
