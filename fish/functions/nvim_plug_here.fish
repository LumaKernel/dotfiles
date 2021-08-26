function nvim_plug_here --wraps nvim
  nvim --cmd "let &rtp = &rtp .. ',' .. '"(pwd)"'" $argv
end
