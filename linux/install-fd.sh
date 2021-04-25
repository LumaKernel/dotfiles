#!/bin/bash

VERSION="8.2.1"
cd /tmp
wget "https://github.com/sharkdp/fd/releases/download/v${VERSION}/fd_${VERSION}_amd64.deb"
sudo dpkg -i "fd_${VERSION}_amd64.deb"
/bin/rm "fd_${VERSION}_amd64.deb"
