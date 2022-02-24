function luma_notebook_start_alone
  if ! _luma_power_check
    return 1
  end

  docker run --rm --name luma-notebook-alone -p 10002:8888 lumakernel/luma-notebook
end
