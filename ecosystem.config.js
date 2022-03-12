module.exports = {
  apps: [
    // For space
    // pm2 start ~/dotfiles/ecosystem.config.js --only=code-server
    {
      name: "code-server",
      watch: false,
      script: "code-server",
      args: "--bind-addr 0.0.0.0:9999",
      interpreter: "none",
      mode: "fork_mode",
    },
    // For WSL
    // pm2 start ~/dotfiles/ecosystem.config.js --only=tailscaled
    {
      name: "tailscaled",
      watch: false,
      script: "sudo",
      args: "tailscaled",
      interpreter: "none",
      mode: "fork_mode",
    },
  ],
};
