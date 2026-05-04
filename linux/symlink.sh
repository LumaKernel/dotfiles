#!/bin/bash

set -euxo pipefail

source "${HOME}/dotfiles/common/symlink.sh"

sudo ln -sf "$HOME"/dotfiles/linux/.bash_profile "$HOME"/.bash_profile
# .bashrc is copied (not symlinked) so that tools can append to it
if [ ! -f "$HOME"/.bashrc ]; then
  cp "$HOME"/dotfiles/linux/bashrc.template "$HOME"/.bashrc
else
  echo "[info] ~/.bashrc already exists, skipping copy. To reset: cp ~/dotfiles/linux/bashrc.template ~/.bashrc"
fi
