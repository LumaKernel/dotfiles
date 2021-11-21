function whouseport
  sudo netstat -tulpn | grep ":$argv[1] "
end
