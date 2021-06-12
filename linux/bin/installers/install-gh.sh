#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION="1.9.2"

cd /tmp || exit

FILENAME="gh_${VERSION}_linux_amd64.deb"
wget "https://github.com/cli/cli/releases/download/v${VERSION}/${FILENAME}"
sudo dpkg -i "${FILENAME}"
/bin/rm "${FILENAME}"
