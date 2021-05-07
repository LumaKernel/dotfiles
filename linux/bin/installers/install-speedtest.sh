#!/bin/bash

# https://www.speedtest.net/apps/cli

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

verify_host install.speedtest.net:443 "4fe715cbcfc7589d9996a274cfa7e70192743628d4cf85d61080d848759f4c32"

curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
sudo apt-get install speedtest
