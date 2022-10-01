function gpg_agent_ssh --wraps ssh
  for help_arg in "--help" "-h"
    if contains -- $help_arg $argv
      echo "[ERROR] Usage: gpg_agent_ssh <ssh args...>"
      return 1
    end
  end

  if test (count $argv) = 0
    echo "[ERROR] Usage: gpg_agent_ssh <ssh args...>"
    return 1
  end

  set GPG_AGENT_RUNNING (pgrep -x gpg-agent 2> /dev/null)
  if test -n "$GPG_AGENT_RUNNING"
    set -l REMOTE_SOCKET (ssh $argv sh -c \'gpgconf --list-dirs agent-socket\')
    if test -z "$REMOTE_SOCKET"
      echo "[ERROR] REMOTE_SOCKET is empty"
      return 1
    end
    ssh $argv sh -c \'rm $REMOTE_SOCKET\'
    ssh $argv -o "RemoteForward $REMOTE_SOCKET "(gpgconf --list-dirs agent-extra-socket)
  else
    echo "[ERROR] GPG Agent is not running."
    echo "[ERROR] gpg_agent_start to start"
    return 1
  end
end
