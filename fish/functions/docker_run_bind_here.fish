function docker_run_bind_here --wraps docker
  docker run --rm -it -v $PWD:/w -w /w --entrypoint "" $argv /bin/sh
end
