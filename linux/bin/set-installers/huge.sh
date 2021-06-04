#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

bash "$SCRIPTS_DIR/bin/installers/install-fnm.sh"
bash "$SCRIPTS_DIR/bin/installers/install-bat.sh"
bash "$SCRIPTS_DIR/bin/installers/install-fd.sh"
bash "$SCRIPTS_DIR/bin/installers/install-gh.sh"
bash "$SCRIPTS_DIR/bin/installers/install-ghq.sh"
bash "$SCRIPTS_DIR/bin/installers/install-goup.sh"
bash "$SCRIPTS_DIR/bin/installers/install-pet.sh"
bash "$SCRIPTS_DIR/bin/installers/install-pyenv.sh"
bash "$SCRIPTS_DIR/bin/installers/install-speedtest.sh"
bash "$SCRIPTS_DIR/bin/installers/install-tpm.sh"
bash "$SCRIPTS_DIR/bin/installers/install-vim.sh"
bash "$SCRIPTS_DIR/bin/installers/install-nvim.sh"
