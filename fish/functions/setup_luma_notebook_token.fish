function setup_luma_notebook_token
  if ! _luma_power_check
    return 1
  end

  echo "LUMA_NOTEBOOK_TOKEN="(openssl rand -hex 64) >> "$HOME/local_profile.sh"
end
