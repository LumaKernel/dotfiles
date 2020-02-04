#!/bin/bash

program="`tmux display -p '#{pane_current_command}'`"

if [[ "$program" = "vim" || "$program" = "nvim" ]]; then
  tmux send-keys "M-$1"
else
  case "$1" in
    j) tmux select-pane -D ;;
    k) tmux select-pane -U ;;
    h) tmux select-pane -L ;;
    l) tmux select-pane -R ;;
  esac
fi

