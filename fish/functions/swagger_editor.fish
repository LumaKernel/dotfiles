function swagger_editor
  set -l port (random 9000 40000)
  if test (count $argv) -eq 0
    docker run --name "dot_sw_ed_$port" -d -p $port:8080 swaggerapi/swagger-editor
  else if test (count $argv) -eq 1
    docker run --name "dot_sw_ed_$port" -e SWAGGER_FILE=/tmp/swagger.json -v (realpath $PWD/$argv[1]):/tmp/swagger.json -d -p $port:8080 swaggerapi/swagger-editor
  else
    echo "ERROR: Should provide 0 or 1 arguments."
    echo "INFO: usage.1: swagger_editor"
    echo "INFO: usage.2: swagger_editor swagger.json"
    return 1
  end
  echo "open http://localhost:$port"
end
