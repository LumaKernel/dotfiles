#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

verify_github

VERSION="1.9.2"

cd /tmp

FLIENAME="gh_${VERSION}_linux_amd64.deb"
wget "https://github.com/cli/cli/releases/download/v${VERSION}/${FLIENAME}"
sudo dpkg -i "${FLIENAME}"
/bin/rm "${FLIENAME}"
