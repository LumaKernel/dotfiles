function luma_notebook_start
  if ! _luma_power_check
    return 1
  end

  if test -z "$LUMA_NOTEBOOK_TOKEN"
    echo "[error] run luma_notebook_setup_token to set LUMA_NOTEBOOK_TOKEN"
    return 1
  end

  set LUMA_NOTEBOOKS_DIR "$HOME/luma-notebooks"
  if ! test -e "$LUMA_NOTEBOOKS_DIR"
    git clone "git@github.com:LumaKernel/luma-notebooks.git" "$LUMA_NOTEBOOKS_DIR"
  end

  docker run --name luma-notebook -d -p 9998:8888 -v "$HOME/luma-notebooks:/home/luma/luma-notebooks" -e NOTEBOOK_ARGS=--NotebookApp.token="$LUMA_NOTEBOOK_TOKEN" lumakernel/luma-notebook
end
