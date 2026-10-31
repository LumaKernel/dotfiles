#!/bin/bash

set -euo pipefail

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

if [ ! -d "$HOME/dotfiles" ]; then
  echo "Not found ~/dotfiles/ dirctory."
  exit 1
fi

# -- symlink の設定
"$HOME/dotfiles/mac/scripts/symlink.sh"

# -- LaunchAgent の設定 (ユーザーの gui ドメインに登録するため root では実行しない)
sudo -u "$SUDO_USER" "$HOME/dotfiles/mac/scripts/install_launchagents.sh"

# -- git の設定
"$HOME/dotfiles/mac/scripts/git-config.sh"

# -- インストール
"$HOME/dotfiles/mac/install.sh"

echo "以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"
