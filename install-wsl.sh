#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

if [ -n -d ~/dotfiles ]; then
  echo "Not found ~/dotfiles/ dirctory."
  exit 1
fi

which cmd.exe >/dev/null 2>&1
is_wsl=$(( ! $? ))

if [[ -n $is_wsl ]]; then
  echo "This installer is for WSL!"
  exit 1
fi

# symlink の設定
bash ~/dotfiles/wsl/symlink.sh

# -- git の設定
bash ~/dotfiles/wsl/install.sh

# -- aptなどでのインストール
bash ~/dotfiles/wsl/install.sh

echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"

