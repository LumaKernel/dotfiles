#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

mkdir -p $HOME/.local/bin

if [[ ! -d "$HOME/.local/bin/tmux-powerline" ]] ; then
  pushd $HOME/.local/bin
    git clone https://github.com/erikw/tmux-powerline.git
  popd
fi
