#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "[Error] Run with sudo."
  exit 1
fi

# link 先がディレクトリなら失敗する
# ( -n で強制できるけど危ないかもしれないので )


ln -sf "$HOME"/dotfiles/init.vim "$HOME"/.vimrc

mkdir -p "$HOME"/.config/nvim
ln -sf "$HOME"/dotfiles/init.vim "$HOME"/.config/nvim/init.vim
ln -sf "$HOME"/dotfiles/ginit.vim "$HOME"/.config/nvim/ginit.vim

ln -sf "$HOME"/dotfiles/linux/.bash_profile "$HOME"/.bash_profile
ln -sf "$HOME"/dotfiles/linux/.bashrc "$HOME"/.bashrc

ln -sf "$HOME"/dotfiles/.gitignore_global "$HOME"/.gitignore_global

ln -sf "$HOME"/dotfiles/.tmux.conf "$HOME"/.tmux.conf
ln -sf "$HOME"/dotfiles/.tmux-powerlinerc "$HOME"/.tmux-powerlinerc

ln -sf "$HOME"/dotfiles/flake8 "$HOME"/.config/flake8
ln -sf "$HOME"/dotfiles/pycodestyle "$HOME"/.config/pycodestyle

mkdir -p "$HOME"/.config/fish/functions
ln -sf "$HOME"/dotfiles/fish/config.fish "$HOME"/.config/fish/config.fish
ln -sf "$HOME"/dotfiles/fish/functions/*.fish "$HOME"/.config/fish/functions

mkdir -p "$HOME"/.config/powerline-shell
test ! -d "$HOME"/.config/powerline-shell/config.json
ln -sf "$HOME"/dotfiles/powerline-shell/config.json "$HOME"/.config/powerline-shell/config.json

mkdir -p "$HOME"/.config/nayvy
test ! -d "$HOME"/.config/nayvy/import_config.nayvy
ln -sf "$HOME"/dotfiles/nayvy/import_config.nayvy "$HOME"/.config/nayvy/import_config.nayvy

mkdir -p "$HOME"/.config/nvim
test ! -d "$HOME"/.config/nvim/coc-settings.json
ln -sf "$HOME"/dotfiles/coc-settings.json "$HOME"/.config/nvim/coc-settings.json
