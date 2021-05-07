#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_github

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip -y

mkdir $HOME/mybuild
cd $HOME/mybuild
VERSION="8.10.5"
if ! test -d "vips-$VERSION"; then
  wget "https://github.com/libvips/libvips/releases/download/v$VERSION/vips-$VERSION.tar.gz"
  tar -xzf "vips-$VERSION.tar.gz"
fi
cd "vips-$VERSION"

./configure
make
sudo make install

