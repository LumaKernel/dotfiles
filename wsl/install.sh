#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "sudo ~/wsl/install.sh"
  exit 1
fi


# -- apt でのインストール
apt-get update -y
apt-get upgrade -y
apt-get autoremove -y

apt-get install python -y
apt-get install clang -y
apt-get install source-highlight -y
apt-get install exuberant-ctags -y

apt-get install silversearcher-ag -y
apt-get install ripgrep -y

apt-get install tmux -y
apt-get install fish -y
apt-get install translate-shell -y



# -- install cquery
if [[ ! -d "$HOME/bin/cquery" ]] ; then
  echo "install cquery!"
  apt-get install clang clang-tools llvm llvm-6.0-tools libclang-6.0-dev -y
  
  mkdir -p $HOME/bin
  pushd $HOME/bin
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


# -- install bashmarks
if [[ ! -e "$HOME/.local/bin/bashmarks.sh" ]] ; then
  mkdir -p $HOME/.tmp
  pushd $HOME/.tmp
    [[ -d "bashmarks" ]] && rm -r bashmarks
    git clone https://github.com/huyng/bashmarks.git
    pushd bashmarks
      cp bashmarks.sh $HOME/.local/bin
    popd
  popd
fi


# -- install tmux-powerline
if [[ ! -d "$HOME/bin/tmux-powerline" ]] ; then
  mkdir -p $HOME/bin
  pushd $HOME/bin
    git clone https://github.com/erikw/tmux-powerline.git
  popd
fi


# -- install tmux-plugins
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]] ; then
  mkdir -p $HOME/.tmux/plugins
  pushd $HOME/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm.git
  popd
fi

# -- install fisher
if [[ ! -e "$HOME/.config/fish/functions/fisher.fish" ]] ; then
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fi

# ---- fisher plugins
fish ~/dotfiles/wsl/install.fish

# -- pip でのインストール
pip install powerline-shell
pip install pylint flake8
pip install thefuck
pip install jedi

