#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT run with sudo."
  exit 1
fi

# -- pip でのインストール
pip install powerline-shell
pip install pylint flake8
pip install pynvim
pip install jedi
pip install trash-cli
