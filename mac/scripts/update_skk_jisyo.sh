#!/bin/bash

MACSKK_DICT_BASE_DIR="$HOME"/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries
mkdir -p "$MACSKK_DICT_BASE_DIR"
for f in $(find "$HOME"/dotfiles/skk-dict -type f); do
  cp "$f" "$MACSKK_DICT_BASE_DIR"
  # https://github.com/mtgto/macSKK/issues/234
  # sudo ln -sf "$f" "$MACSKK_DICT_BASE_DIR"/"$(basename "$f")"
done

f="$HOME/ghq/github.com/LumaKernel/skk-emoji-jisyo/SKK-JISYO.emoji.utf8"
if [ -f "$f" ]; then
  cp "$f" "$MACSKK_DICT_BASE_DIR"
else
  echo "[WARN] 辞書ファイルが見つかりません: $f"
fi
