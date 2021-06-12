#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
# shellcheck source=../../utils/shared.sh
source "$SCRIPTS_DIR/utils/shared.sh"

mkdir -p "$HOME/.local/bin"

# -- install cquery
if [[ ! -d "$HOME/.local/bin/cquery" ]] ; then
  echo "install cquery!"
  apt-get install clang clang-tools llvm llvm-6.0-tools libclang-6.0-dev -y

  mkdir -p "$HOME/.local/bin"
  pushd "$HOME/.local/bin" || exit
    git clone --recursive https://github.com/cquery-project/cquery.git
    cd cquery || exit
    git submodule update --init

    mkdir build
    pushd build || exit
      cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=release -DCMAKE_EXPORT_COMPILE_COMMANDS=YES
      cmake --build .
      cmake --build . --target install
    popd || exit
  popd || exit
fi
