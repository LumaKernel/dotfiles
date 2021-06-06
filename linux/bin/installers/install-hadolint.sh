#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION="2.4.1"

cd /tmp
FILENAME="hadolint-Linux-x86_64"
/bin/rm "${FILENAME}"
wget "https://github.com/hadolint/hadolint/releases/download/v${VERSION}/${FILENAME}"
sudo install "${FILENAME}" /usr/local/bin/hadolint
/bin/rm "${FILENAME}"
