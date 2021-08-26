function swagger_editor_clean
  set -l names (_swagger_editor_names)
  if test (count $names) -gt 0
    docker rm -f $names
  end
end
