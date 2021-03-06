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

ln -sf ~/dotfiles/mac/.bash_profile ~/.bash_profile
ln -sf ~/dotfiles/mac/.bashrc ~/.bashrc

ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global

ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tmux-powerlinerc ~/.tmux-powerlinerc

mkdir -p ~/.config/fish/functions
ln -sf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -sf ~/dotfiles/fish/functions/*.fish ~/.config/fish/functions

mkdir -p ~/.config/powerline-shell
ln -sf ~/dotfiles/powerline-shell/config.json ~/.config/powerline-shell/config.json
