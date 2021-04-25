function node_generate_password
  node -e "require('crypto').randomBytes(48, function(err, buffer) { var token = buffer.toString('hex'); console.log(token); });"
end
