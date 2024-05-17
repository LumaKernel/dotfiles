#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

VERSION=1.22.2

INSTALL_TMP_DIR="/tmp/install-go-tmp"
rm -rf "$INSTALL_TMP_DIR"
mkdir -p /tmp/install-go-tmp
cd /tmp/install-go-tmp || return
curl -fsSL "https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz" -o "go${VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go${VERSION}.linux-amd64.tar.gz"

rm -rf "$INSTALL_TMP_DIR"
