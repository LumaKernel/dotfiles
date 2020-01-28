#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

which cmd.exe >/dev/null 2>&1
is_wsl=$(( ! $? ))

if [[ -n $is_wsl ]]; then
  echo "This installer is for WSL!"
  exit 1
fi

mkdir -p ~/.config/nvim

ln -sf ~/dotfiles/init.vim ~/.vimrc
ln -sf ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles/ginit.vim ~/.config/nvim/ginit.vim
ln -sf ~/dotfiles/wsl/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/wsl/.bashrc ~/.bashrc
ln -sf ~/dotfiles/vim/coc-settings.json ~/.config/nvim

# -- git の設定
git config --global core.ignorecase false
git config --global core.quotepath false
git config --global core.safecrlf true
git config --global core.autocrlf false


# -- apt でのインストール
# TODO : 別ファイルに移す
apt-get install python -y
apt-get install clang -y
apt-get install source-highlight -y


# ---- install cquery
command -v cquery >/dev/null 2>&1
if [[ -n $? ]] ; then
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



echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"

