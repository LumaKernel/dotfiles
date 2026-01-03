#!/bin/bash

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "${HOME}/dotfiles/common/symlink.sh"

sudo ln -sf "$HOME"/dotfiles/mac/.bash_profile "$HOME"/.bash_profile
sudo ln -sf "$HOME"/dotfiles/mac/.bashrc "$HOME"/.bashrc
sudo ln -sf "$HOME"/dotfiles/mac/.yabairc "$HOME"/.yabairc
sudo ln -sf "$HOME"/dotfiles/mac/.skhdrc "$HOME"/.skhdrc

mkdir -p "$HOME"/.config/alacritty
sudo ln -sf "$HOME"/dotfiles/alacritty/alacritty.toml "$HOME"/.config/alacritty/alacritty.toml

GHOSTTY_CONFIG_DIR="${HOME}/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"
sudo ln -sf "$HOME"/dotfiles/ghostty/config "$GHOSTTY_CONFIG_DIR"/config

"$SCRIPT_DIR"/update_skk_jisyo.sh

is_symlink_mac() {
  is_symlink_TYPE="$(stat -f %Sp "$1" | cut -b 1)"
  test "$is_symlink_TYPE" = l
}

TO_DIRNAME="$HOME/Library/Application Support/Code/User"
TO="$TO_DIRNAME/settings.json"
if ! is_symlink_mac "$TO"; then
  mkdir -p "$TO_DIRNAME"
  sudo ln -sf "$HOME/dotfiles/vscode/user/settings.json" "$TO"
else
  echo "[warn] $TO already exists and not symlink"
fi

TO="$TO_DIRNAME/keybindings.json"
if ! is_symlink_mac "$TO"; then
  mkdir -p "$TO_DIRNAME"
  sudo ln -sf "$HOME/dotfiles/vscode/user/keybindings.json" "$TO"
else
  echo "[warn] $TO already exists and not symlink"
fi
