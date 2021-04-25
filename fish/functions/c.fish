function c \
    --description 'clear and tmux clear-history'
  clear
  if command -v tmux >/dev/null 2>&1
    tmux clear-history
  end
end
