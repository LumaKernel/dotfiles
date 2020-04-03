#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

VER="0.13.0"
Installed=""
command -v bat >/dev/null 2>/dev/null && Installed="1"

if [[ -z "$Installed" ]]; then
  pushd /tmp
    wget https://github.com/sharkdp/bat/releases/download/v${VER}/bat_${VER}_amd64.deb
    sudo dpkg -i bat_${VER}_amd64.deb
    /bin/rm bat_${VER}_amd64.deb
  popd
else
  echo "bat is found."
fi
