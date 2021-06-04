#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION="0.3.0"

cd /tmp

FILENAME="pet_${VERSION}_linux_amd64.deb"
wget "https://github.com/knqyf263/pet/releases/download/v${VERSION}/${FILENAME}"
sudo dpkg -i "$FILENAME"
/bin/rm "${FILENAME}"
