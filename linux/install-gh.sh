#!/bin/bash

VERSION="1.5.0"
cd /tmp
wget "https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.deb"
sudo dpkg -i "gh_${VERSION}_linux_amd64.deb"
/bin/rm "gh_${VERSION}_linux_amd64.deb"
