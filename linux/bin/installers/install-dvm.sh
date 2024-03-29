#!/bin/bash

set -eo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

curl -fsSL https://deno.land/x/dvm/install.sh | sh
