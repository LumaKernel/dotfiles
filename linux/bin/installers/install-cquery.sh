#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

mkdir -p $HOME/.local/bin

# -- install cquery
if [[ ! -d "$HOME/.local/bin/cquery" ]] ; then
  echo "install cquery!"
  apt-get install clang clang-tools llvm llvm-6.0-tools libclang-6.0-dev -y

  mkdir -p $HOME/.local/bin
  pushd $HOME/.local/bin
    git clone --recursive https://github.com/cquery-project/cquery.git
    cd cquery
    git submodule update --init

    mkdir build
    pushd build
      cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=release -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
      cmake --build .
      cmake --build . --target install
    popd
  popd
fi
