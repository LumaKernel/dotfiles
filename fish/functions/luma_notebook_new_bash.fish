function luma_notebook_start
  if ! _luma_power_check
    return 1
  end

  set -l USER_ARG
  if test "$argv[1]" = '--root'
    echo "[info] root mode"
    set USER_ARG -- -u root
  else
    echo "[info] Not root mode. Supply --root to enable root mode."
  end

  if test -z "$LUMA_NOTEBOOK_TOKEN"
    echo "[error] run luma_notebook_setup _token to set LUMA_NOTEBOOK_TOKEN"
    return 1
  end

  mkdir -p "$HOME/luma-notebooks" || true

  docker run --rm -it $USER_ARG --entrypoint '' lumakernel/luma-notebook bash
end
