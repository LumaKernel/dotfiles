#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

volta run --node 20.10.0 --npm 10.2.5 npm install -g @microsoft/inshellisense
