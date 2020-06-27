#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Run in normal user"
  exit 1
fi

# brew install
command -v brew >/dev/null 2>&1 ||
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew bundle --file=Brewfile

# # ---- ocaml TODO
# apt-get install opam -y
# su $SUDO_USER -c "opam init -n >/dev/null --disable-sandboxing"

# -- TODO
apt-get install python-software-properties -y
apt-get install golang-stable -y

apt-get install silversearcher-ag -y
apt-get install ripgrep -y


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

# ---- fisher plugins
fish ~/dotfiles/wsl/install.fish

# TODO: 対象ごとに分類

command -v pip >/dev/null 2>&1
if [[ "$?" != "0" ]]; then
  pyenv install 3.8.1
  pyenv global 3.8.1
  eval "$(pyenv init)"
fi

# -- pip でのインストール
pip install powerline-shell
pip install pylint flake8
pip install pynvim
pip install jedi
pip install trash-cli

# -- ocaml TODO
# opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git -y
# opam install ocaml-lsp-server -y
# opam install ocp-indent -y
