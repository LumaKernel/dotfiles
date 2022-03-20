#!/bin/bash
# Vultr instance tested.

if [ "$(whoami)" == "root" ]; then
  echo "[error] Run in normal user."
  echo "[info] - Set up /etc/sudoers"
  exit 1
fi

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if test "$LUMA_POWER" != "1"; then
  echo 'export LUMA_POWER=1' >> "$HOME/local_profile.sh"
fi

apt update
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
  silversearcher-ag \
  ripgrep \
  rlwrap \
  cmake \
  fish \
  nmap \
  net-tools \
  iproute2 \
  tmux \
  sqlite3 \
  shellcheck

# Docker
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker "$(whoami)"

"${SCRIPT_DIR}/../scripts/git-config.sh"
"${SCRIPT_DIR}/../scripts/setup-vim-python3.sh"
"${SCRIPT_DIR}/linux/bin/set-installers/huge.sh"
curl -fsSL https://code-server.dev/install.sh | sh
curl -fsSL https://tailscale.com/install.sh | sh

echo "[info] TODO"
echo "[info] - bound block storage?"
echo "[info] - link block storage as docker image dir?"
echo "[info] - npm i -g pnpm"
echo "[info] - pnpm i -g pm2"
echo "[info] - sudo tailscale up"
echo "[info] - luma_notebook_build"
echo "[info] - luma_notebook_start"
echo "[info] - luma_code_server_start"
echo "[info] - luma_revproxy_start"
echo "[info] - set up firewall?"
echo "[info]     sudo ufw allow 41641/udp"
echo "[info]     sudo ufw allow 3478/udp"
echo "[info] - set up dns?"
