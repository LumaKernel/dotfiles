#!/bin/bash

echo "TODO"
exit 1

# TODO: いるこれ？

update-alternatives --install `which vim` vim `which nvim` 60
update-alternatives --set vim `which nvim`
