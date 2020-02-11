
echo "fish/config.fish"

# -- powerline-shell
function fish_mode_prompt
end
function fish_prompt
  set -x powerline_fish_key_bindings $fish_key_bindings
  set -x powerline_fish_bind_mode $fish_bind_mode
  powerline-shell --shell bare $status
  set -e powerline_fish_key_bindings
  set -e powerline_fish_bind_mode
end

fish_vi_key_bindings

source ~/dotfiles/fish/alias.fish


# TODO: FIX
bash "$NVM_DIR/nvm.sh"

