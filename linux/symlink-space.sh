#!/bin/bash

# POSIX Shell script function to ensure file removed with backing up with rotating.
rotate_remove() {
  set -eu
  rotate_remove_FILE="$1"
  if ! test -e "$rotate_remove_FILE"; then
    return
  fi
  rotate_remove_N=0
  while test -e "$rotate_remove_FILE.bak.$rotate_remove_N"; do
    rotate_remove_N="$(expr "$rotate_remove_N" + 1)"
  done
  while test "$rotate_remove_N" != 0; do
    rotate_remove_P="$rotate_remove_N"
    if test "$rotate_remove_N" = 1; then
      rotate_remove_N=0
    else
      rotate_remove_N="$(expr "$rotate_remove_N" - 1)"
    fi
    mv "$rotate_remove_FILE.bak.$rotate_remove_N" "$rotate_remove_FILE.bak.$rotate_remove_P"
  done
  mv "$rotate_remove_FILE" "$rotate_remove_FILE.bak.0"
}

is_symlink() {
  is_symlink_TYPE="$(stat "$1" --format %A | cut -b 1)"
  test "$is_symlink_TYPE" = l
}

set -euxo pipefail

TO_DIRNAME="$HOME"/.local/share/code-server/User
TO="$HOME"/.local/share/code-server/User/settings.json
if ! is_symlink "$TO"; then
  mkdir -p "$TO_DIRNAME"
  sudo ln -sf "$HOME/dotfiles/vscode/user/settings.json" "$TO"
else
  echo "[warn] $TO already exists and not symlink"
fi

TO_DIRNAME="$HOME"/.local/share/code-server/User
TO="$HOME"/.local/share/code-server/User/keybindings.json
if ! is_symlink "$TO"; then
  mkdir -p "$TO_DIRNAME"
  sudo ln -sf "$HOME/dotfiles/vscode/user/keybindings.json" "$TO"
else
  echo "[warn] $TO already exists and not symlink"
fi
