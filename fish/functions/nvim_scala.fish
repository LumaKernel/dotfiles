function nvim_scala --wraps nvim
  VIM_COMPLETE_MODE=metals VIM_LSP_MODE=none nvim $argv
end
