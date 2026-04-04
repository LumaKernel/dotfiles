function clean_trashed --description '*.trashed ファイル/ディレクトリを削除 (デフォルトはdry-run)'
  set -l is_force ""
  if contains -- --force $argv
    or contains -- -f $argv
    set is_force 1
  end

  set -l targets (find . -name '*.trashed' -maxdepth 5 2>/dev/null)

  if test (count $targets) -eq 0
    echo "[info/clean_trashed]: *.trashed が見つかりませんでした"
    return 0
  end

  for target in $targets
    if test -n "$is_force"
      trash $target
      echo "削除: $target"
    else
      echo $target
    end
  end

  if test -n "$is_force"
    echo
    echo "[info/clean_trashed]: 完了"
  else
    echo
    echo "[info/clean_trashed]: dry-run モードで実行中"
    echo "[info/clean_trashed]: 実際に削除するには '-f' または '--force' を指定してください"
  end
end

complete -c clean_trashed -s f -l force -d '実際に削除する (dry-runではなく)'
