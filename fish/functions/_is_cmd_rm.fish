set -l SUDO_ALLOWLIST "chmod" "chown"

function _is_cmd_rm --inherit-variable SUDO_ALLOWLIST
  set -l input "$argv"
  string match --regex --quiet -- '^(\.?/)?bin/rm\s+' $input
end
