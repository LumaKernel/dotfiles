function python3_serve_local --description 'Serve current directory'
  set port $argv[1]
  if test -z $port
    set port 2020
  end
  python3 -m http.server $port
end

