function gpg_agent_start
  set WHICH_GPG_AGENT (which gpg-agent 2> /dev/null)
  if test -n "$WHICH_GPG_AGENT"
    set GPG_AGENT_RUNNING (pgrep -x gpg-agent 2> /dev/null)
    if test -n "$GPG_AGENT_RUNNING"
      echo "gpg-agent is already running."
      set -gx GPG_TTY (tty)
    else
      echo "gpg-agent starting..."
      set -gx GPG_TTY (tty)
      LANG=C gpg-connect-agent updatestartuptty /bye
    end

    if test -z "$LUMA_IS_MAC"
      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end
    echo "env var configured."
    echo "Use ssh-add ... to add SSH keys."
  else
    echo "gpg-agent NOT installed"
  end
end
