function _is_cmd_rm
  set -l input "$argv"
  string match --regex --quiet -- '^(\.?/)?bin/rm\s+' $input
end
