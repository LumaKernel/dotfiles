if command -v corepack > /dev/null
  function npm --wraps=npm
    time corepack npm $argv
  end
end
