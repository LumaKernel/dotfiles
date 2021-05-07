#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$(dirname "$SCRIPT_DIR")/utils/get_fingerprint.sh"

get_fingerprint "$1"
