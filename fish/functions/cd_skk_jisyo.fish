if test "$LUMA_IS_MAC" = "1"
  function cd_skk_jisyo
    set -l MACSKK_DICT_BASE_DIR $HOME/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries
    cd $MACSKK_DICT_BASE_DIR
  end
end
