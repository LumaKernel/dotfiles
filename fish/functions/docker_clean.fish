# Clean all my automated processes.
function docker_clean
  set -l names (docker ps -a --format '{{(.Names)}}' | awk '$1 ~ /^dot_/{print $1}')
  if test (count $names) -gt 0
    docker rm -f $names
  end
end
