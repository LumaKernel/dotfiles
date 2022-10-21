function rm_venv
  if test -f venv/bin/activate
    /bin/rm -rf ./venv
  else
    echo "[ERROR] venv/bin/activate file not found."
    return 1
  end
end
