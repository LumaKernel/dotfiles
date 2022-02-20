function start_luma_notebook
  if test "$LUMA_POWER" != "1"
    echo "[error] LUMA_POWER is not 1. Luma notebook needs huge power."
    return 1
  end
  mkdir -p "$HOME/luma-notebooks"
  docker run -p 10001:8888 -v "$HOME/luma-notebooks:/home/luma/luma-notebooks" luma-kernel/luma-notebooks
end
