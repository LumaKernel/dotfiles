function notify
  switch (uname)
    case Darwin
      osascript -e "display notification \"$argv\" with title \"notify\""
    case '*'
      echo "notify: unsupported platform" >&2
      return 1
  end
end
