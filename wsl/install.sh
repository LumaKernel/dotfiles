#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

# -- apt でのインストール
apt-get update -y
apt-get upgrade -y

apt-get install python -y
apt-get install clang -y
apt-get install source-highlight -y
apt-get install exuberant-ctags -y
apt-get install silversearcher-ag -y


# -- install cquery
command -v cquery >/dev/null 2>&1
if (( $? )) ; then
  apt-get install clang clang-tools llvm llvm-6.0-tools libclang-6.0-dev -y

  mkdir -p $HOME
  pushd $HOME
    rm -r cquery
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


# -- pip でのインストール
pip install powerline-shell
pip install pylint flake8
pip install thefuck

