#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

set -euxo pipefail

TMP_DIR=/tmp/luma-install-onedrive
rm -rf "${TMP_DIR}"
mkdir -p "${TMP_DIR}"

# https://github.com/abraunegg/onedrive/blob/master/docs/ubuntu-package-install.md
sudo apt-get remove onedrive
sudo add-apt-repository --remove ppa:yann1ck/onedrive || true
sudo rm -f /etc/systemd/user/default.target.wants/onedrive.service

wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_22.04/ ./" | sudo tee /etc/apt/sources.list.d/onedrive.list
sudo apt-get update
sudo apt-get install -y --no-install-recommends --no-install-suggests onedrive

rm -rf "${TMP_DIR}"
