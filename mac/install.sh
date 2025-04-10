#!/bin/bash

set -euo pipefail

if [ "$(whoami)" == "root" ]; then
  echo "Run in normal user"
  exit 1
fi

# brew install
command -v /opt/homebrew/bin/brew >/dev/null 2>&1 ||
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

command -v brew >/dev/null 2>&1 || export PATH="/opt/homebrew/bin:$PATH"

sudo softwareupdate --install-rosetta
brew bundle --file="$HOME/dotfiles/Brewfile"

"$HOME/dotfiles/mac/scripts/install_mas.sh"

# cargo install
# TODO: linux?
"$HOME/dotfiles/linux/bin/installers/install-rust-tools.sh"

# -- install tmux-plugins
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]] ; then
  mkdir -p $HOME/.tmux/plugins
  pushd $HOME/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm.git
    ./tpm/bin/install_plugins
  popd
fi

# -- install fisher
if [[ ! -e "$HOME/.config/fish/functions/fisher.fish" ]] ; then
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fi
