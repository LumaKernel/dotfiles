function complete_if_non_empty
  test -n (commandline)
    and commandline -f complete
end
