function nvim_plug_here
  nvim --cmd "let &rtp = &rtp .. ',' .. expand('%:h:p')" $argv
end
