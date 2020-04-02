#!/bin/bash

if [ "`whoami`" != "root" -a "$SUDO_USER" != "" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

if [ ! -d ~/dotfiles ]; then
  echo "Not found ~/dotfiles/ dirctory."
  exit 1
fi

uname -a | grep microsoft >/dev/null 2>/dev/null
is_wsl=$(( ! $? ))

if (( ! $is_wsl )); then
  echo "This installer is for WSL!"
  exit 1
fi

# symlink の設定
bash ~/dotfiles/wsl/symlink.sh

# -- git の設定
bash ~/dotfiles/scripts/git-config.sh

# -- aptなどでのインストール
bash ~/dotfiles/wsl/install.sh

echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"


