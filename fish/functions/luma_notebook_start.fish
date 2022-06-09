function luma_notebook_start
  if ! _luma_power_check
    return 1
  end

  if test -z "$LUMA_NOTEBOOK_TOKEN"
    echo "[error] run luma_notebook_setup_token to set LUMA_NOTEBOOK_TOKEN"
    return 1
  end

  mkdir -p "$HOME/luma-notebooks" || true

  docker run --name luma-notebook -d -p 9998:8888 -v "$HOME/luma-notebooks:/home/luma/luma-notebooks" -e NOTEBOOK_ARGS=--NotebookApp.token="$LUMA_NOTEBOOK_TOKEN" lumakernel/luma-notebook
end
