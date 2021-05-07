#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

verify_github

mkdir -p $HOME/.local/bin

if [[ ! -d "$HOME/.local/bin/tmux-powerline" ]] ; then
  pushd $HOME/.local/bin
    git clone https://github.com/erikw/tmux-powerline.git
  popd
fi
