#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

TAG=origin/master
NAME=nightly
PRIORITY=10

if test -n "$1"; then
  TAG=$1
  NAME=$1
  PRIORITY=20
fi

sudo apt-get update
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

mkdir "$HOME/mybuild" || true
cd "$HOME/mybuild"
if ! test -d neovim; then
  git clone https://github.com/neovim/neovim.git
fi

cd neovim
git fetch
git reset --hard HEAD
git checkout "$TAG"
make USERNAME=luma HOSTNAME= CMAKE_BUILD_TYPE=RelWithDebInfo
export PREFIX_DIR="$HOME/.local/build/nvim/$NAME"
mkdir -p "$PREFIX_DIR"
make install CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$PREFIX_DIR"
export INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
sudo update-alternatives --install "$INSTALL_DIR/nvim" nvim "$HOME/.local/build/nvim/$NAME/bin/nvim" $PRIORITY
