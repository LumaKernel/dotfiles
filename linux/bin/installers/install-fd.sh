#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

verify_github

VERSION="8.2.1"

cd /tmp
FILENAME="fd_${VERSION}_amd64.deb"
/bin/rm "${FILENAME}"
wget "https://github.com/sharkdp/fd/releases/download/v${VERSION}/${FILENAME}"
sudo dpkg -i "${FILENAME}"
/bin/rm "${FILENAME}"
