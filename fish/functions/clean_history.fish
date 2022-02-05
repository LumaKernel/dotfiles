function clean_history
  set -l HISTORY_PATH "$HOME/.local/share/fish/fish_history"

  set -l is_force ""
  if contains -- --force $argv
    or contains -- -f $argv
    set is_force 1
  end

  if test -n "$is_force"
    if test -f "$HISTORY_PATH.2.bak"
      cp "$HISTORY_PATH.2.bak" "$HISTORY_PATH.3.bak"
    end
    if test -f "$HISTORY_PATH.1.bak"
      cp "$HISTORY_PATH.1.bak" "$HISTORY_PATH.2.bak"
    end
    if test -f "$HISTORY_PATH.0.bak"
      cp "$HISTORY_PATH.0.bak" "$HISTORY_PATH.1.bak"
    end
    cp "$HISTORY_PATH" "$HISTORY_PATH.0.bak"
    sed -i -e 's/\t\+/ /g' "$HISTORY_PATH"
  end

  for hist in (history)
    if _is_cmd_force $hist
      or _is_cmd_sudo_danger $hist
      or _is_cmd_rm $hist
      or _is_cmd_kill $hist
      if test -n "$is_force"
        history delete --exact --case-sensitive $hist
      else
        echo $hist
      end
    end
  end

  if test -n "$is_force"
    echo "[info/clean_history]: run 're' to refresh"
  else
    echo
    echo "[info/clean_history]: running with dry-run mode"
    echo "[info/clean_history]: run with '-f' or '--force' flag to delete them"
    echo "[info/clean_history]: prepend spaces to avoid being the command listed"
  end
end

complete -c clean_history -s f -l force -d 'Execute'
