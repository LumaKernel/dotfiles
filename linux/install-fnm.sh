#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_host fnm.vercel.app:443 "20ea135b10eb92ea36adb0149204ae60f56436afddec7eef05ff5c8229b38d8b"

curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm" --skip-shell
