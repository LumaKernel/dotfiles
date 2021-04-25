if [ "$is_WSL" = 1 ]
  function h \
      --description 'explorer.exe .'
    explorer.exe .
  end
else
  function h
    echo "[Error] h is only for WSL."
  end
end
