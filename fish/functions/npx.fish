if command -v corepack > /dev/null
  function npx --wraps=npx
    time corepack npx $argv
  end
end
