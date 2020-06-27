#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

if [ -n -d ~/dotfiles ]; then
  echo "Not found ~/dotfiles/ dirctory."
  exit 1
fi

# -- symlink の設定
bash ~/dotfiles/mac/symlink.sh

# -- git の設定
bash ~/dotfiles/mac/git-config.sh

# -- インストール
bash ~/dotfiles/mac/install.sh

echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"
