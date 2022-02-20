#!/bin/bash

set -euo pipefail

sudo yum update -y

# nvm (node)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install node

# tools
sudo yum groupinstall -y "Development Tools"
sudo yum install -y gcc git
sudo amazon-linux-extras install epel -y
sudo yum install util-linux-user -y

# docker
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl enable docker.servic

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# fish shell

