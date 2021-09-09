#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION="1.0.2"
ARCH=$(arch)

cd /tmp || exit

FILENAME="fish-history-ui_${VERSION}_Linux_${ARCH}.tar.gz"
wget "https://github.com/luma-dev/fish-history-ui/releases/download/v${VERSION}/${FILENAME}"
tar -xvf "$FILENAME"
sudo install fish-history-ui /usr/local/bin/
echo "${FILENAME}" ./fish-history-ui
rm "$FILENAME" ./fish-history-ui
