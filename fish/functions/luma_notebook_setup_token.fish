function luma_notebook_setup_token
  if ! _luma_power_check
    return 1
  end

  echo "export LUMA_NOTEBOOK_TOKEN="(openssl rand -hex 24) >> "$HOME/local_profile.sh"
end
