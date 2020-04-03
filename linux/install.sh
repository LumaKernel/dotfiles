#!/bin/bash

if [ "`whoami`" != "root" -o "$SUDO_USER" = "" ]; then
  echo "[Error] Run with sudo."
  exit 1
fi

# -- apt でのインストール
add-apt-repository ppa:avsm/ppa -y
add-apt-repository ppa:gophers/go -y
apt-add-repository ppa:fish-shell/release-3 -y
apt-add-repository ppa:git-core/ppa -y

apt-get update -y
apt-get upgrade -y
apt-get autoremove -y

apt-get install git zip cargo -y
apt-get install clang -y
apt-get install source-highlight -y
apt-get install exuberant-ctags -y

# ---- ocaml
# TODO: sudo でやるのはとりあえずまずい
# apt-get install opam -y
# su $SUDO_USER -c "opam init -n >/dev/null --disable-sandboxing"

# ---- go
apt-get install python-software-properties -y
apt-get install golang-stable -y

apt-get install silversearcher-ag -y
apt-get install ripgrep -y

apt-get install tmux -y
apt-get install fish -y

# -- install tmux-powerline
su $SUDO_USER -c bash $HOME/dotfiles/linux/install-tmux-powerline.sh

# -- install tpm
su $SUDO_USER -c bash $HOME/dotfiles/linux/install-tpm.sh


# -- install fisher
if [[ ! -e "$HOME/.config/fish/functions/fisher.fish" ]] ; then
  curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
fi


# ---- fisher plugins
fish $HOME/dotfiles/wsl/install.fish

# -- pip でのインストール
su $SUDO_USER -c bash $HOME/dotfiles/linux/pip-install.sh

# -- cargo でのインストール
su $SUDO_USER -c bash $HOME/dotfiles/linux/cargo-install.sh

# -- ocaml
# TODO: 使うときになったら
# su $SUDO_USER -c npm install -g ocaml-language-server
# su $SUDO_USER -c "opam install merlin -y"
# opam user-setup install -y
# su $SUDO_USER -c "opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git -y"
# su $SUDO_USER -c "opam install ocaml-lsp-server -y"
# su $SUDO_USER -c "opam install ocp-indent -y"
