function git_local_config_as_luma --description 'Set git local config as Luma'
  if test (count $argv) -gt 0
    echo 'Error: This command does not accept any arguments'
    return 1
  end
  git config --local user.email world@luma.email
  git config --local user.name 'Luma'
end
