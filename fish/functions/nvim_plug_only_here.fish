function nvim_plug_only_here
  nvim -u DEFAULTS --cmd "let &rtp = expand('%:h:p') .. ',' .. &rtp" $argv
end
