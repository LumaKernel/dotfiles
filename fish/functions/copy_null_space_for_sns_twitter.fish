if test "$LUMA_IS_MAC" = 1
  function copy_null_space_for_sns_twitter
    echo_null_space_for_sns_twitter | pbcopy
  end
else if test "$is_WSL" = 1
  function copy_null_space_for_sns_twitter
    echo_null_space_for_sns_twitter | win32yank.exe -i
  end
else
  function copy_null_space_for_sns_twitter
    echo "[Error] copy_null_space_for_sns_twitter is only for macOS or WSL."
  end
end
