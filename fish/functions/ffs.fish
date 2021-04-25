function ffp \
    --description 'docker sjourdan/ffprobe'
  docker run -it --rm -v "$PWD":/tmp/h -w "/tmp/h" sjourdan/ffprobe $argv
end
