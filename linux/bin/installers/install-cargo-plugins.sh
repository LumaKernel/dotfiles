#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

cargo install cargo-watch
cargo install cargo-install-update
cargo install cargo-outdated
cargo install cargo-add
cargo install cargo-expand
