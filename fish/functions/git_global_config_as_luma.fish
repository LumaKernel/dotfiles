function git_global_config_as_luma --description 'Set git global config as Luma'
  if test (count $argv) -gt 0
    echo 'Error: This command does not accept any arguments'
    return 1
  end
  git config --global user.email world@luma.email
  git config --global user.name 'Luma'
end
