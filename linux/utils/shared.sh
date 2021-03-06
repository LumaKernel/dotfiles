#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../utils/get_fingerprint.sh
source "$SCRIPTS_DIR/utils/get_fingerprint.sh"
