#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

mkdir -p "$HOME/.tmux/plugins"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]] ; then
  pushd "$HOME/.tmux/plugins" || exit
    git clone https://github.com/tmux-plugins/tpm.git
    ./tpm/bin/install_plugins
  popd || exit
fi
