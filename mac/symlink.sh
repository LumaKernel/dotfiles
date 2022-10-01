#!/bin/bash

set -euxo pipefail

source "${HOME}/dotfiles/common/symlink.sh"

sudo ln -sf "$HOME"/dotfiles/mac/.bash_profile "$HOME"/.bash_profile
sudo ln -sf "$HOME"/dotfiles/mac/.bashrc "$HOME"/.bashrc
