#!/bin/bash

set -euox pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

# https://releases.hashicorp.com/terraform-ls/
VERSION="0.31.2"

cd /tmp
FILENAME="terraform-ls_${VERSION}_linux_amd64.zip"
BINNAME="terraform-ls"

/bin/rm "${FILENAME}" || true
/bin/rm "${BINNAME}" || true

# wget "https://github.com/hashicorp/terraform-ls/releases/download/v${VERSION}/${FILENAME}"
wget "https://releases.hashicorp.com/terraform-ls/${VERSION}/${FILENAME}" -O "${FILENAME}"
unzip "${FILENAME}"
test -x "${BINNAME}"
sudo install "${BINNAME}" /usr/local/bin

/bin/rm "${FILENAME}" || true
/bin/rm "${BINNAME}" || true
