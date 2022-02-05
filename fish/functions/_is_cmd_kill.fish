function _is_cmd_kill
  set -l input "$argv"
  string match --regex --quiet -- '^p?kill\s+' $input
end
