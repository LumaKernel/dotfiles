#!/bin/bash
set -e

VENV="nvim"
TO_INSTALL="pynvim pyls pyls-mypy"


mkdir -p $HOME/.local/venvs | true
cd $HOME/.local/venvs
python3 -m venv $VENV
./$VENV/bin/pip3 install -U pip
./$VENV/bin/pip3 install $TO_INSTALL
echo "$PWD/$VENV/bin"
