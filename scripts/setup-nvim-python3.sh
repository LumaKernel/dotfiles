#!/bin/bash

set -e

mkdir -p $HOME/.local/venvs | true
cd $HOME/.local/venvs
VENV="nvim"
python3 -m venv $VENV
./$VENV/bin/pip3 install -U pip
./$VENV/bin/pip3 install pynvim
echo "$PWD/$VENV/bin"
