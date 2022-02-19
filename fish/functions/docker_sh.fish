function docker_sh
  set -l container_name $argv[1]
  set -e argv[1]
  set -l sh_commands '
  if command -v bash > /dev/null; then
    exec bash
  elif command -v ash > /dev/null; then
    exec ash
  elif command -v fish > /dev/null; then
    exec fish
  else
    exec sh
  fi
  '
  docker run -it --entrypoint '' $argv "$container_name" sh -c "$sh_commands"
end
