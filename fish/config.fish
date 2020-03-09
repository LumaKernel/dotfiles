
echo "fish/config.fish"

# -- powerline-shell
function fish_prompt
  set -x powerline_fish_key_bindings $fish_key_bindings
  set -x powerline_fish_bind_mode $fish_bind_mode
  powerline-shell --shell bare $status
  set -e powerline_fish_key_bindings
  set -e powerline_fish_bind_mode
end

fish_vi_key_bindings

source ~/dotfiles/fish/alias.fish

# -- ローカルパス
set -x PATH ~/.local/bin $PATH

# XXX: 役立ってるかわからん
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# -- less
export LESS='-R --no-init -g -j10 --quit-if-one-screen'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

# -- cquery
command -v cquery >/dev/null 2>&1
  and set -x PATH $PATH $HOME/bin/cquery/build/release/bin

# -- themis
command -v themis >/dev/null 2>&1
  and set -x PATH $PATH $HOME/.cache/dein/repos/github.com/thinca/vim-themis/bin

# -- pyenv
command -v pyenv >/dev/null 2>&1
  and source (pyenv init -|psub)


# TODO: dircolors は必要？
# TODO: opam env

