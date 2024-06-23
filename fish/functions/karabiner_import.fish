function karabiner_import --description 'Import a Karabiner-Elements complex modification JSON file. Usage: karabiner_import /path/to/config.json' -a json_path
  if test ! -f $json_path
    echo "[ERROR] File not found: $json_path"
    return 1
  end
  open "karabiner://karabiner/assets/complex_modifications/import?url=file://"(realpath $json_path)
end
