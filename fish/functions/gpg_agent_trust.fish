function gpg_agent_trust --wraps ssh
  for help_arg in "--help" "-h"
    if contains -- $help_arg $argv
      echo "[ERROR] Usage: gpg_agent_trust <gpg key id> <ssh args...>"
      return 1
    end
  end

  if test (count $argv) -lt 2
    echo "[ERROR] Usage: gpg_agent_trust <gpg key id> <ssh args...>"
    return 1
  end

  set -l key_id $argv[1]
  set -l ssh_argv $argv[2..]
  gpg --export $key_id | ssh $ssh_argv sh -c \'gpg --import - ';' sh -c '"echo 5;echo y;"' '|' gpg --command-fd 0 --expert --no-tty --edit-key $key_id trust\'
end
