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

# -- git の設定
git config --global core.ignorecase false
git config --global core.quotepath false
git config --global core.safecrlf true
git config --global core.autocrlf false


# -- powerline-shell のインストール
apt-get install python -y
pip install powerline-shell



echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"

