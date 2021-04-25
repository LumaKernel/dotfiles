if ! type fd >/dev/null 2>&1
  if command -v fdfind >/dev/null 2>&1
    alias fd=fdfine
  end
end
