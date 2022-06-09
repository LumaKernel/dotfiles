#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

bash "$SCRIPTS_DIR/bin/installers/install-volta.sh"
~/.volta/bin/volta install node
bash "$SCRIPTS_DIR/bin/installers/install-dvm.sh"
~/.dvm/bin/dvm install
bash "$SCRIPTS_DIR/bin/installers/install-go.sh"
bash "$SCRIPTS_DIR/bin/installers/install-bat.sh"
bash "$SCRIPTS_DIR/bin/installers/install-fd.sh"
bash "$SCRIPTS_DIR/bin/installers/install-gh.sh"
bash "$SCRIPTS_DIR/bin/installers/install-ghq.sh"
bash "$SCRIPTS_DIR/bin/installers/install-pet.sh"
bash "$SCRIPTS_DIR/bin/installers/install-pyenv.sh"
bash "$SCRIPTS_DIR/bin/installers/install-speedtest.sh"
bash "$SCRIPTS_DIR/bin/installers/install-tpm.sh"
bash "$SCRIPTS_DIR/bin/installers/install-rustup.sh"
bash "$SCRIPTS_DIR/bin/installers/install-cargo-plugins.sh"
bash "$SCRIPTS_DIR/bin/installers/install-rust-tools.sh"
bash "$SCRIPTS_DIR/bin/installers/install-vim.sh"
bash "$SCRIPTS_DIR/bin/installers/install-nvim.sh" "v0.7.0"
