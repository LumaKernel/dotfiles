function nvimc --wraps nvim
  VIM_COMPLETE_MODE=coc VIM_LSP_MODE=coc nvim $argv
end
