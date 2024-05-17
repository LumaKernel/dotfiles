#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

set -euxo pipefail

TMP_DIR=/tmp/luma-install-code
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"
curl -fsSL --proto '=https' "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o "${TMP_DIR}/code.deb"
sudo apt-get install -y "${TMP_DIR}/code.deb"

rm -rf "${TMP_DIR}"
