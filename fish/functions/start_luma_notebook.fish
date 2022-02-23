function start_luma_notebook
  if ! _luma_power_check
    return 1
  end

  if test -z "$LUMA_NOTEBOOK_TOKEN"
    echo "[error] run setup_luma_notebook_token to set LUMA_NOTEBOOK_TOKEN"
    return 1
  end

  mkdir -p "$HOME/luma-notebooks" || true
  docker run --name luma-notebook -p 10001:8888 -v "$HOME/luma-notebooks:/home/luma/luma-notebooks" lumakernel/luma-notebook --NotebookApp.token="$LUMA_NOTEBOOK_TOKEN"
end
