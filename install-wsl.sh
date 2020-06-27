#!/bin/bash

if [ "`whoami`" != "root" -a "$SUDO_USER" != "" ]; then
  echo "Run with sudo."
  exit 1
fi

if [ ! -d $HOME/dotfiles ]; then
  echo "Not found ~/dotfiles/ dirctory."
  exit 1
fi

uname -a | grep microsoft >/dev/null 2>/dev/null
is_wsl=$(( ! $? ))

# symlink の設定
bash ~/dotfiles/linux/symlink.sh

# -- git の設定
bash ~/dotfiles/scripts/git-config.sh

# -- aptなどでのインストール
bash ~/dotfiles/linux/install.sh
