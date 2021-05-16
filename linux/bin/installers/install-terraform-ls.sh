#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION="0.16.3"

cd /tmp
FILENAME="terraform-ls_${VERSION}_linux_amd64.zip"
BINNAME="terraform-ls"

/bin/rm "${FILENAME}" || true
/bin/rm "${BINNAME}" || true

wget "https://github.com/hashicorp/terraform-ls/releases/download/v${VERSION}/${FILENAME}"
unzip "${FILENAME}"
test -x "${BINNAME}"
sudo install "${BINNAME}" /usr/local/bin

/bin/rm "${FILENAME}" || true
/bin/rm "${BINNAME}" || true
