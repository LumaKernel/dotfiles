#!/bin/bash

set -eo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

TAG=origin/master
NAME=HEAD
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
if ! test -d vim; then
  git clone https://github.com/vim/vim.git
fi

cd vim
git fetch
git reset --hard HEAD
git checkout "$TAG"

# make distclean
export INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"
./configure --enable-fail-if-missing --with-features=huge --with-compiledby=luma --prefix="$PREFIX"
make
sudo make install
sudo update-alternatives --install "$INSTALL_DIR/vim" vim "$HOME/.local/build/vim/$NAME/bin/vim" $PRIORITY
