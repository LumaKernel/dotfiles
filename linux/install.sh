#!/bin/bash

# -- apt でのインストール
# add-apt-repository ppa:avsm/ppa -y
# add-apt-repository ppa:gophers/go -y
# apt-add-repository ppa:fish-shell/release-3 -y
# apt-add-repository ppa:git-core/ppa -y

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

sudo apt-get install git zip cargo -y
sudo apt-get install python3 python3-venv python3-pip -y
sudo apt-get install clang -y
sudo apt-get install source-highlight -y
sudo apt-get install exuberant-ctags -y

# ---- ocaml
sudo apt-get install opam -y
# opam init -n >/dev/null --disable-sandboxing

sudo apt-get install python-software-properties -y

sudo apt-get install ripgrep -y

sudo apt-get install tmux -y
sudo apt-get install fish -y
sudo apt-get install rlwrap -y

# -- install tmux-powerline
bash "$HOME/dotfiles/linux/install-tmux-powerline.sh"

# -- install tpm
bash "$HOME/dotfiles/linux/install-tpm.sh"


# -- install fisher
if [[ ! -e "$HOME/.config/fish/functions/fisher.fish" ]] ; then
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fi


# ---- fisher plugins
fish "$HOME/dotfiles/wsl/install.fish"

# -- pip でのインストール
bash "$HOME/dotfiles/linux/pip-install.sh"

# -- ocaml
# TODO
# npm install -g ocaml-language-server
# opam install ocamlfind num merlin -y
# opam user-setup install -y
# opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git -y
# opam install ocaml-lsp-server -y
# opam install ocp-indent -y
