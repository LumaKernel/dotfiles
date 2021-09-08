function docker_here_node --wraps docker
  set -l suf (random 100000 999999)
  docker run --rm -it -v $PWD:/w -w /w --entrypoint "" --name "dot_here_node_"$suf $argv node:14-alpine /bin/ash
end
