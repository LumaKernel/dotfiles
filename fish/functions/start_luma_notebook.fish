function start_luma_notebook
  if ! _luma_power_check
    return 1
  end

  mkdir -p "$HOME/luma-notebooks" || true
  docker run --name luma-notebook -p 10001:8888 -v "$HOME/luma-notebooks:/home/luma/luma-notebooks" lumakernel/luma-notebook
end
