function _is_cmd_force
  set -l input "$argv"
  string match --regex --quiet -- '^git\s+clean\s+[^\s]*f' $input
  or string match --regex --quiet -- '^clean_history.*(\s-f\b|\s--force\b)' $input
end
