function docker_tcpdump
  set -l container_name $argv[1]
  set -e argv[1]
  set -l sh_commands '
  if ! command -v tcpdump > /dev/null; then
    if command -v apt-get > /dev/null; then
      apt-get update
      apt-get install -y tcpdump
    elif command -v apk > /dev/null; then
      apk update
      apk add tcpdump
    else
      echo "ERROR: docker-tcpdump: no configured package manager."
      exit 1
    fi
  fi

  if test '(count $argv)' = 0; then
    tcpdump -X -s 0
  else
    tcpdump '"$argv"'
  fi
  '
  docker exec -it -u root "$container_name" sh -c "$sh_commands"
end
