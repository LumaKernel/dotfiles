function dcc \
    --description 'docker-compose exec $argv /bin/bash'
  repl docker-compose exec $argv /bin/bash
end
