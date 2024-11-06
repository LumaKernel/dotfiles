if test "$LUMA_IS_MAC" = "1"
  function whouseport
    sudo lsof -i -P | grep LISTEN | grep ":$argv[1] "
  end
else
  function whouseport
    sudo netstat -tulpn | grep ":$argv[1] "
  end
end
