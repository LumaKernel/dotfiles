#!/bin/bash

MACSKK_DICT_BASE_DIR="$HOME"/Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents/Dictionaries
mkdir -p "$MACSKK_DICT_BASE_DIR"
for f in $(find "$HOME"/dotfiles/skk-dict -type f); do
  cp "$f" "$MACSKK_DICT_BASE_DIR"
  # https://github.com/mtgto/macSKK/issues/234
  # sudo ln -sf "$f" "$MACSKK_DICT_BASE_DIR"/"$(basename "$f")"
done

files=(
  "github.com/LumaKernel/skk-emoji-jisyo/SKK-JISYO.emoji.utf8"
  "github.com/LumaKernel/private-skk-dict/skk-dict/SKK-JISYO.private-luma.utf8.txt"
)
for file in "${files[@]}"; do
  file_path="$HOME/ghq/${file}"
  if [ ! -f "$file_path" ]; then
    echo "[WARN] 辞書ファイルが見つかりません: $file_path"
    echo "[INFO] インストールします"
    repo_path="$(echo "$file" | cut -d'/' -f1-3)"
    dir="$HOME/ghq/$repo_path"
    mkdir -p "$(dirname dir)"
    repo_git_url="https://$repo_path"
    git clone $repo_git_url "$dir"
  fi
  cp "$file_path" "$MACSKK_DICT_BASE_DIR"
done
