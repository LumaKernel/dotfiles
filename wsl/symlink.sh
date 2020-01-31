#!/bin/bash

if [ "`whoami`" != "root" ]; then
  echo "Run with 'sudo'"
  exit 1
fi

# link 先がディレクトリなら失敗する
# ( -n で強制できるけど危ないかもしれないので )


ln -sf ~/dotfiles/init.vim ~/.vimrc

mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles/ginit.vim ~/.config/nvim/ginit.vim
ln -sf ~/dotfiles/vim/coc-settings.json ~/.config/nvim

ln -sf ~/dotfiles/wsl/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/wsl/.bashrc ~/.bashrc

ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global

mkdir -p ~/.config/powerline-shell
ln -sf ~/dotfiles/powerline-shell/config.json ~/.config/powerline-shell/config.json

