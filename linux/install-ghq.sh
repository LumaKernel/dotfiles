#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_github

if command -v go 2>/dev/null; then
  go get github.com/x-motemen/ghq
else
  echo "[Error] go not installed."
  echo "[Hint] Install goup."
  echo "[Hint] Run 'goup install'"
fi
