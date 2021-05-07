#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

verify_github

VERSION="0.7.2"

cd /tmp
FILENAME="shellcheck-v${VERSION}.linux.x86_64.tar.xz"
/bin/rm "$FILENAME"
wget "https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/${FILENAME}"
sudo dpkg -i "${FILENAME}"
/bin/rm "${FILENAME}"
