#!/bin/bash

set -euxo pipefail

# link 先がディレクトリなら失敗する
# ( -n で強制できるけど危ないかもしれないので )


# ~/.config/nvim
# sudo ln -sf "$HOME"/dotfiles/init.vim "$HOME"/.vimrc

mkdir -p "$HOME"/.config/nvim
sudo ln -sf "$HOME"/dotfiles/init.lua "$HOME"/.config/nvim/init.lua
# sudo ln -sf "$HOME"/dotfiles/ginit.vim "$HOME"/.config/nvim/ginit.vim


sudo ln -sf "$HOME"/dotfiles/.gitignore_global "$HOME"/.gitignore_global

sudo ln -sf "$HOME"/dotfiles/.tmux.conf "$HOME"/.tmux.conf
sudo ln -sf "$HOME"/dotfiles/.tmux-powerlinerc "$HOME"/.tmux-powerlinerc

sudo ln -sf "$HOME"/dotfiles/flake8 "$HOME"/.config/flake8
sudo ln -sf "$HOME"/dotfiles/pycodestyle "$HOME"/.config/pycodestyle

mkdir -p "$HOME"/.config/fish
sudo ln -sf "$HOME"/dotfiles/fish/config.fish "$HOME"/.config/fish/config.fish

mkdir -p "$HOME"/.config/powerline-shell
test ! -d "$HOME"/.config/powerline-shell/config.json
sudo ln -sf "$HOME"/dotfiles/powerline-shell/config.json "$HOME"/.config/powerline-shell/config.json

mkdir -p "$HOME"/.config/nayvy
test ! -d "$HOME"/.config/nayvy/import_config.nayvy
sudo ln -sf "$HOME"/dotfiles/nayvy/import_config.nayvy "$HOME"/.config/nayvy/import_config.nayvy

mkdir -p "$HOME"/.config/nvim
test ! -d "$HOME"/.config/nvim/coc-settings.json
sudo ln -sf "$HOME"/dotfiles/coc-settings.json "$HOME"/.config/nvim/coc-settings.json
