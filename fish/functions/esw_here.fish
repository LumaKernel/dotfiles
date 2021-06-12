function esw_here
  npx -p eslint-watch esw . --ext .js,.ts,.tsx,.json,.vue -w --changed --fix-dry-run $argv
end
