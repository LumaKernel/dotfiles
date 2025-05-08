#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

cargo binstall --no-confirm bacon --features "clipboard sound"
cargo binstall --no-confirm cargo-outdated
cargo binstall --no-confirm cargo-edit
cargo binstall --no-confirm cargo-expand
cargo binstall --no-confirm cargo-generate
cargo binstall --no-confirm cargo-insta
cargo binstall --no-confirm watchexec-cli
