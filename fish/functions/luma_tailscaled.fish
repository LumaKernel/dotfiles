function luma_tailscaled
  set subcommand $argv[1]

  if test -z "$subcommand"
    echo "subcommand:"
    echo "  - start"
    echo "  - log"
    echo "  - stop"
    echo "  - delete"
    echo "  - restart"
    echo "  - startOrRestart"
    return 1
  end

  pm2 $subcommand ~/dotfiles/ecosystem.config.js --only=tailscaled
end
