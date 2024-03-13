# shellcheck shell=bash

# Return if not interactive.
case $- in
    *i*) ;;
      *) return;;
esac

echo "[info/.bashrc] mac mode"
export LUMA_IS_MAC=1

if test -x /opt/homebrew/bin/brew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "[warn/.bashrc] Brew not installed"
fi

source "${HOME}/dotfiles/common/bashrc.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash" || true
