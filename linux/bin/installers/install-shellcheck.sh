#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION="0.7.2"

cd /tmp
FILENAME="shellcheck-v${VERSION}.linux.x86_64.tar.xz"
DIRNAME="shellcheck-v${VERSION}"

/bin/rm "${FILENAME}"
/bin/rm -r "${DIRNAME}"

wget "https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/${FILENAME}"
tar -xf "${FILENAME}"
sudo install "${DIRNAME}/shellcheck" /usr/local/bin/shellcheck

/bin/rm "${FILENAME}"
/bin/rm -r "${DIRNAME}"
