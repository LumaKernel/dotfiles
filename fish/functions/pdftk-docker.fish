function pdftk-docker
    docker run --rm --volume (pwd):/work pdftk/pdftk:latest $argv
end
