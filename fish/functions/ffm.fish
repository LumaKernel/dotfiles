function ffm \
    --description 'docker jrottenberg/ffmpeg'
  docker run --rm -it -v "$PWD":/tmp/h -w "/tmp/h" jrottenberg/ffmpeg $argv
end
