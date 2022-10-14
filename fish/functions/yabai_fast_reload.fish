function yabai_fast_reload
  if test -n "$LUMA_IS_MAC"
    echo "[ERROR] yabai_fast_reload is only for mac"
    return 1
  end
  launchctl kickstart -k "gui/$UID/homebrew.mxcl.yabai"
end
