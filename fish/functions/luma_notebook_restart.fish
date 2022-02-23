function luma_notebook_restart
  if ! _luma_power_check
    return 1
  end

  docker stop luma-notebook || true
  docker rm -f luma-notebook || true
  luma_notebook_start
end
