#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

if command -v go 2>/dev/null; then
  go get github.com/x-motemen/ghq
else
  echo "[Error] go not installed."
  echo "[Hint] Install goup."
  echo "[Hint] Run 'goup install'"
fi
