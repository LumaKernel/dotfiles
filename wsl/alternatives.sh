#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

update-alternatives --install `which vim` vim `which nvim` 60
update-alternatives --set vim `which nvim`

