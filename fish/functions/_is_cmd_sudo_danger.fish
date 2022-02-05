set -l SUDO_ALLOWLIST "chmod" "chown" "echo" "apt" "apt-get" "lsof" "cat" "service" "tcpdump" "install" "dpkg" "update-alternatives" "netstat" "add-apt-repository" "apt-add-repository"

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
