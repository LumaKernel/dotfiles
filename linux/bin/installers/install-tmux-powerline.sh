#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

mkdir -p "$HOME/.local/bin"

if [[ ! -d "$HOME/.local/bin/tmux-powerline" ]] ; then
  pushd "$HOME/.local/bin" || exit
    git clone https://github.com/erikw/tmux-powerline.git
  popd || exit
fi
