set -l SUDO_ALLOWLIST "chmod" "chown" "echo" "apt" "apt-get" "lsof" "cat"

function _is_cmd_sudo_danger --inherit-variable SUDO_ALLOWLIST
  set -l input "$argv"

  if ! string match --regex --quiet -- '^sudo\s+' $input
    return 1
  end

  for cmd in $SUDO_ALLOWLIST
    if string match --regex --quiet -- '^sudo\s+'$cmd $input
      return 1
    end
  end
  return 0
end
