#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

if command -v go 2>/dev/null; then
  go install github.com/x-motemen/ghq@latest
else
  echo "[Error] go not installed."
  echo "[Hint] Install go."
fi
