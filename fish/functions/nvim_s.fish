function nvim_s --wraps nvim
  VIM_COMPLETE_MODE=ddc VIM_LSP_MODE=none nvim $argv
end
