#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

mkdir -p $HOME/.tmux/plugins

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]] ; then
  pushd $HOME/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm.git
    ./tpm/bin/install_plugins
  popd
fi