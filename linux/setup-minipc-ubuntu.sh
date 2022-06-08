#!/bin/bash
# Vultr instance tested.

if [ "$(whoami)" == "root" ]; then
  echo "[error] Run in normal user."
  echo "[info] - Set up /etc/sudoers"
  exit 1
fi

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
DOTFILES_DIR="$(dirname "$(dirname "$(dirname "$SCRIPT_DIR")")")"

if test "$LUMA_POWER" != "1"; then
  echo 'export LUMA_POWER=1' >> "$HOME/local_profile.sh"
fi

sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt-get install -y \
  git \
  jq \
  zip \
  python3 \
  python3-venv \
  python3-pip \
  fzf \
  source-highlight \
  clang \
  exuberant-ctags \
  ripgrep \
  rlwrap \
  cmake \
  fish \
  nmap \
  net-tools \
  iproute2 \
  tmux \
  sqlite3 \
  shellcheck \
  trash-cli

"${DOTFILES_DIR}/linux/scripts/git-config.sh"
"${DOTFILES_DIR}/linux/scripts/setup-vim-python3.sh"
"${DOTFILES_DIR}/linux/bin/set-installers/huge.sh"
curl -fsSL https://code-server.dev/install.sh | sh

echo "[info] TODO"
echo "[info] - bound block storage?"
echo "[info] - link block storage as docker image dir?"
echo "[info] - npm i -g pnpm"
echo "[info] - pnpm i -g pm2"
echo "[info] - luma_notebook_build"
echo "[info] - luma_notebook_start"
echo "[info] - luma_code_server_start"
echo "[info] - luma_revproxy_start"
echo "[info] - set up firewall?"
echo "[info]     sudo ufw allow 41641/udp"
echo "[info]     sudo ufw allow 3478/udp"
echo "[info] - set up dns?"
echo "[info] - install ...?"
echo "[info]   - docker"
echo "[info]   - tailscale"
