function curl_json --wraps curl --description 'e.g. curl_json localhost:8080 -d\'{"name":"Alice"}\''
   curl -H'Content-Type: application/json' $argv
end
