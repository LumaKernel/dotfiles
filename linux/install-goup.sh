#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_github

curl -sSf https://raw.githubusercontent.com/owenthereal/goup/master/install.sh | sh
