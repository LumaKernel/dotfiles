# shellcheck shell=bash

# Return if not interactive.
case $- in
    *i*) ;;
      *) return;;
esac

echo "[info/.bashrc] mac mode"

if test -x /opt/homebrew/bin/brew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "[warn/.bashrc] Brew not installed"
fi

source "${HOME}/dotfiles/common/bashrc.sh"
