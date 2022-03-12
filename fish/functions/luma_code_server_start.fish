function luma_code_server_start
  if ! _luma_power_check
    return 1
  end

  luma_code_server start
end
