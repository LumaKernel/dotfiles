function gpg_agent_start
  set WHICH_GPG_AGENT (which gpg-agent 2> /dev/null)
  if test -n "$WHICH_GPG_AGENT"
    set GPG_AGENT_RUNNING (pgrep -x gpg-agent 2> /dev/null)
    if test -n "$GPG_AGENT_RUNNING"
      echo "gpg-agent is already running."
    else
      echo "gpg-agent starting..."
      set -x GPG_TTY (tty)
      LANG=C gpg-connect-agent updatestartuptty /bye
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end

    set -gx GPG_TTY (tty)
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    echo "env var configured."
    echo "Use ssh-add ... to add SSH keys."
  else
    echo "gpg-agent NOT installed"
  end
end
