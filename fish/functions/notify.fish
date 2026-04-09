switch (uname)
  case Darwin
    function notify --description 'Show a desktop notification (macOS only)'
      if contains -- -h $argv; or contains -- --help $argv
        echo "Usage: notify <message>"
        echo ""
        echo "Show a desktop notification."
        echo "Supported platforms: macOS (osascript)."
        return 0
      end
      osascript -e "display notification \"$argv\" with title \"notify\""
    end
  case '*'
    function notify --description 'Show a desktop notification (unsupported platform)'
      echo "notify: unsupported platform" >&2
      return 1
    end
end
