#!/bin/bash

if [ "$(whoami)" == "root" ]; then
  echo "Run in normal user"
  exit 1
fi

# brew install
command -v brew >/dev/null 2>&1 ||
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle --file="$HOME/dotfiles/Brewfile"


# 以下，git で自分でインストール

# -- install tmux-powerline
if [[ ! -d "$HOME/bin/tmux-powerline" ]] ; then
  mkdir -p $HOME/bin
  pushd $HOME/bin
    git clone https://github.com/erikw/tmux-powerline.git
  popd
fi

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

command -v pip >/dev/null 2>&1
if [[ "$?" != "0" ]]; then
  pyenv install 3.8.1
  pyenv global 3.8.1
  eval "$(pyenv init)"
fi
