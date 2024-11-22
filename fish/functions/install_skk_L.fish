function install_skk_L
  set -l temp_dir (mktemp -d)
  set -l MACSKK_DICT_BASE_DIR $HOME/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries

  set -l skk_jisyo_dir ""
  if test "$LUMA_IS_MAC" = "1"
    set skk_jisyo_dir $MACSKK_DICT_BASE_DIR
  else
    echo "[ERROR] Unsupported OS"
    return 1
  end

  echo "[INFO] Temporally directory made: $temp_dir"
  curl --proto '=https' --tlsv1.2 -sSf -L https://skk-dev.github.io/dict/SKK-JISYO.L.gz -o $temp_dir/SKK-JISYO.L.gz
  gunzip $temp_dir/SKK-JISYO.L.gz
  mv $temp_dir/SKK-JISYO.L $skk_jisyo_dir/my-SKK-JISYO.L
  command rm -rf $temp_dir
  echo "[INFO] Temporally directory removed"
end
