#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

mkdir -p $HOME/.pyenv
pushd $HOME/.pyenv
# -- install pyenv

# dependencies
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
if [ ! -d .git ]; then
  git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
else
  echo "[Info] pyenv is already installed."
fi

popd
