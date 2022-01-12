function sccache_redis
  mkdir -p $HOME/.cache/sccache_redis/data
  docker rm -f sccache_redis
  echo "SCCACHE_REDIS_PORT=$SCCACHE_REDIS_PORT"
  docker run -itd --name sccache_redis -v $HOME/.cache/sccache_redis/data:/data -p $SCCACHE_REDIS_PORT:6379 redis
  du -h -d 0 $HOME/.cache/sccache_redis/data
end
