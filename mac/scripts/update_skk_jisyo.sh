#!/bin/bash

MACSKK_DICT_BASE_DIR="$HOME"/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries
mkdir -p "$MACSKK_DICT_BASE_DIR"
for f in $(find "$HOME"/dotfiles/skk-dict -type f); do
  cp "$f" "$MACSKK_DICT_BASE_DIR"
  # sudo ln -sf "$f" "$MACSKK_DICT_BASE_DIR"/"$(basename "$f")"
done

