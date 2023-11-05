function sccache --wraps=sccache
  AWS_ACCESS_KEY_ID=$SCCACHE_AWS_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=$SCCACHE_AWS_SECRET_ACCESS_KEY \
  command sccache $argv
end
