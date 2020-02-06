
echo "fish/config.fish"
set -e fish_key_bindings
set -e fish_bind_mode

# -- powerline-shell
function fish_mode_prompt
end
function fish_prompt
  set -x fish_key_bindings $fish_key_bindings
  set -x fish_bind_mode $fish_bind_mode
  powerline-shell --shell bare $status
end

fish_vi_key_bindings

source ~/dotfiles/fish/alias.fish

bash "$NVM_DIR/nvm.sh"

