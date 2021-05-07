#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_github

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

mkdir $HOME/mybuild
cd $HOME/mybuild
if ! test -d vim; then
  git clone https://github.com/vim/vim.git
fi

cd vim
git fetch
git switch origin/nightly
make USERNAME=luma HOSTNAME= CMAKE_BUILD_TYPE=RelWithDebInfo
make install CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=$HOME/.local/build/nvim/nightly
sudo update-alternatives --install $HOME/.local/bin/nvim nvim $HOME/.local/build/nvim/nightly/bin/nvim 10

