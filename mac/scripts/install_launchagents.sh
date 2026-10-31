#!/bin/bash

# Installs mac/launchagents/*.plist into ~/Library/LaunchAgents and (re)loads them.
# Must run as the login user (not root): LaunchAgents belong to the user's gui/<uid> domain.
# Called from install-mac.sh via `sudo -u "$SUDO_USER"`.

set -euxo pipefail

if [ "$(id -u)" = 0 ]; then
  echo "Run as the login user, not root"
  exit 1
fi

mkdir -p "$HOME"/Library/LaunchAgents

# Copied (not symlinked) because launchd may ignore symlinked plists at login
for plist in "$HOME"/dotfiles/mac/launchagents/*.plist; do
  label="$(basename "$plist" .plist)"
  cp "$plist" "$HOME"/Library/LaunchAgents/
  launchctl bootout gui/"$(id -u)"/"$label" 2>/dev/null || true
  launchctl bootstrap gui/"$(id -u)" "$HOME"/Library/LaunchAgents/"$label".plist
done
