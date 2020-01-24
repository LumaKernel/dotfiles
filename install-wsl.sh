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


apt-get install python -y
pip install powerline-shell

