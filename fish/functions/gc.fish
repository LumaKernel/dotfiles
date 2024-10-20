function gc --wraps='git commit' --description 'alias gc=git commit'
  if ! git config --local user.email
    echo "[ERROR] Please set your email address with 'git config --local user.email'"
    return 1
  end
  git commit $argv
end
