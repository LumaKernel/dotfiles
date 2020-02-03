
echo "fish/config.fish"

# -- powerline-shell
function fish_prompt
  powerline-shell --shell bare $status
end

source ~/dotfiles/fish/alias.fish

