if [ "$is_WSL" = 1 ]
  alias cdwin='cd "$WinHome"'
else
  function cdwin
    echo "[Error] cdwin is only for WSL."
  end
end

