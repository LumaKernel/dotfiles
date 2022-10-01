#!/bin/bash

set -euxo pipefail

source "${HOME}/dotfiles/common/symlink.sh"

sudo ln -sf "$HOME"/dotfiles/linux/.bash_profile "$HOME"/.bash_profile
sudo ln -sf "$HOME"/dotfiles/linux/.bashrc "$HOME"/.bashrc
