#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

mkdir -p "$HOME/.pyenv"
pushd "$HOME/.pyenv" || exit

# -- install pyenv

# dependencies
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
if [ ! -d .git ]; then
  git clone https://github.com/pyenv/pyenv.git "$HOME/.pyenv"
else
  echo "[Info] pyenv is already installed."
  echo "[Info] Updating..."
  if git pull; then
    echo "[Info] Update is done."
  else
    echo "[Error] Update is failed."
    exit 1
  fi
fi

popd || exit
