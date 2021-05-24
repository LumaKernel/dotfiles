set -l SUDO_ALLOWLIST "chmod" "chown"

function clean_history --inherit-variable SUDO_ALLOWLIST
  set -l HISTORY_PATH "$HOME/.local/share/fish/fish_history"
  cp "$HISTORY_PATH" "$HISTORY_PATH.bak"
  sed -i -e 's/\t\+/ /g' "$HISTORY_PATH"

  for hist in (history search --prefix '/bin/rm ')
    history delete --exact --case-sensitive $hist
  end

  for hist in (history search --prefix 'sudo ')
    for cmd in $SUDO_ALLOWLIST
      if string match --regex --quiet '^sudo '$cmd $hist
        continue
      end
    end
    history delete --exact --case-sensitive $hist
  end

  echo "Run 're' to refresh."
end
