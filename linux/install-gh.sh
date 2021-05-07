#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_github

VERSION="1.7.0"
cd /tmp
wget "https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.deb"
sudo dpkg -i "gh_${VERSION}_linux_amd64.deb"
/bin/rm "gh_${VERSION}_linux_amd64.deb"
