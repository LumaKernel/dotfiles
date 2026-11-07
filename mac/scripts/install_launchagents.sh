#!/bin/bash

# Syncs mac/launchagents/*.plist into ~/Library/LaunchAgents. Safe to re-run at any time:
#   - new or changed plist      -> copy and (re)load
#   - unchanged and loaded      -> skip (RunAtLoad jobs are NOT re-run)
#   - removed from the repo     -> unload and trash (only plists carrying INSTALLED_MARKER)
# Every plist in mac/launchagents/ must contain INSTALLED_MARKER as a comment, or removal won't be synced.
# Must run as the login user (not root): LaunchAgents belong to the user's gui/<uid> domain.
# Called from install-mac.sh via `sudo -u "$SUDO_USER"`.

set -euxo pipefail
shopt -s nullglob

if [ "$(id -u)" = 0 ]; then
  echo "Run as the login user, not root"
  exit 1
fi

SRC_DIR="$HOME/dotfiles/mac/launchagents"
DEST_DIR="$HOME/Library/LaunchAgents"
DOMAIN="gui/$(id -u)"
INSTALLED_MARKER="Installed by mac/scripts/install_launchagents.sh"

mkdir -p "$DEST_DIR"

# Copied (not symlinked) because launchd may ignore symlinked plists at login
for plist in "$SRC_DIR"/*.plist; do
  label="$(basename "$plist" .plist)"
  dest="$DEST_DIR/$label.plist"
  if cmp -s "$plist" "$dest" && launchctl print "$DOMAIN/$label" >/dev/null 2>&1; then
    echo "[skip] $label is up to date"
    continue
  fi
  cp "$plist" "$dest"
  launchctl bootout "$DOMAIN/$label" 2>/dev/null || true
  launchctl bootstrap "$DOMAIN" "$dest"
done

for dest in "$DEST_DIR"/*.plist; do
  grep -q "$INSTALLED_MARKER" "$dest" || continue
  label="$(basename "$dest" .plist)"
  [ -f "$SRC_DIR/$label.plist" ] && continue
  launchctl bootout "$DOMAIN/$label" 2>/dev/null || true
  trash "$dest"
done
