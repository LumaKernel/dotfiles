# shellcheck shell=bash

# References
# - /etc/skel/.bashrc
# - http://www.unixuser.org/~euske/doc/bashtips/bashrc.html

echo "[info/enter] common/bashrc.sh"

# local profile
LOCAL_PROFILE_FILEPATH="$HOME/local_profile.sh"
if test -f "$LOCAL_PROFILE_FILEPATH"; then
  echo "[info/.bashrc/local_profile] $LOCAL_PROFILE_FILEPATH found"
  source "$LOCAL_PROFILE_FILEPATH"
else
  echo "[warn/.bashrc/local_profile] $LOCAL_PROFILE_FILEPATH not found"
fi

# for mac
# https://support.apple.com/en-us/HT208050
export BASH_SILENCE_DEPRECATION_WARNING=1

# VSCODE_GIT_ASKPASS_NODE includes "Cursor Helper"
IS_CURSOR=0
if [[ -n "$VSCODE_GIT_ASKPASS_NODE" && "$VSCODE_GIT_ASKPASS_NODE" == *"Cursor Helper"* ]]; then
  echo "[info/.bashrc] Cursor is detected."
  IS_CURSOR=1
fi
export IS_CURSOR

# https://code.visualstudio.com/docs/terminal/shell-integration and not IS_CURSOR
if test "$TERM_PROGRAM" == "vscode" && test "$IS_CURSOR" = 0; then
  source "$(code --locate-shell-integration-path bash)"
  export NO_FISH=1
fi

# shell name
export SHELL_NAME=bash

# ---- vim の環境変数を削除
unset VIM
unset VIMRUNTIME
unset MYVIMRC
unset MYGVIMRC

# ---- パスを追加
# pip のライブラリなど
if test -z "$LUMA_WORLD_BIN_DIR"; then
  export LUMA_WORLD_BIN_DIR="$HOME/.local/bin"
  export PATH="$LUMA_WORLD_BIN_DIR:$PATH"
fi

# ヒストリーをファイルに保存
shopt -s histappend
HISTCONTROL=ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s cdspell  # cd の小さなスペルミスを修正
shopt -s checkwinsize  # ${COLUMNS} と ${LINES} を winsize に同期
shopt -s no_empty_cmd_completion  # 何も入力してないなら補完しない
shopt -s nocaseglob  # glob で ignorecase

command -v powerline-shell >/dev/null 2>&1
if (( ! $? )) ; then

  function _update_ps1() {
    PS1=$(powerline-shell $?)
  }

  if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
  fi
else
  echo "[info/healthcheck/.bashrc] powerline-shell not installed."
fi

# ---- colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ---- nextword
export NEXTWORD_DATA_PATH="$HOME/.local/share/nextword/nextword-data-large"

# ---- fzf
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_DEFAULT_COMMAND='rg --hidden --files --iglob !.git --iglob !venv --iglob "!*.class" --iglob "!*.tasty" --iglob "!target/"'
export FZF_CTRL_T_COMMAND='fd --hidden --exclude ".git" --exclude "venv" $dir'
file_viewer="( \
  command -v bat 2>&1 >/dev/null && \
  bat --pager=never --color=always --style=numbers {} 2>/dev/null || \
  cat {} 2>/dev/null )"
dir_viewer="( \
  command -v exa 2>&1 >/dev/null && \
  exa --tree --color always {} 2>/dev/null || \
  ls {} 2>/dev/null )"
export FZF_DEFAULT_OPTS="$(printf -- '--tabstop=4 --reverse --preview "%s || %s || echo \"<no preview>\""' "$file_viewer" "$dir_viewer")"

# ---- less
export LESS='-R --no-init -g -j10 --quit-if-one-screen'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

# ---- cargo
if test -z "$CARGO_BIN_PATH"; then
  export CARGO_BIN_PATH="$HOME/.cargo/bin"
  export PATH="$CARGO_BIN_PATH:$PATH"
fi

# ---- delete my fish envs
export fish_key_bindings=
export fish_bind_mode=

# -- python
if test -z "$PYTHON_TOOLS_PATH"; then
  export PYTHON_TOOLS_PATH="$HOME/.local/venvs/tools/bin"
  export PATH="$PATH:$PYTHON_TOOLS_PATH"
fi

# -- go
if test -z "$GO_PATH"; then
  export GO_PATH="/usr/local/go/bin"
  export PATH="$GO_PATH:$HOME/go/bin:$PATH"
fi

# -- ghcup
if test -z "$GHCUP_PATH"; then
  export GHCUP_PATH="$HOME/.ghcup/bin"
  export PATH="$GHCUP_PATH:$PATH"
fi

# -- pnpm
if test -z "$PNPM_HOME"; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
  export PATH="$PNPM_HOME:$PATH"
fi

# -- elan
if test -z "$ELAN_HOME"; then
  export ELAN_HOME="$HOME/.elan"
  export PATH="$ELAN_HOME/bin:$PATH"
fi

# -- gem
# if command -v gem >/dev/null 2>&1; then
#   if test -z "$GEM_BIN_DIR"; then
#     export GEM_BIN_DIR=$(gem environment gemdir)/bin
#     export PATH="$GEM_BIN_DIR:$PATH"
#   fi
# else
#   echo "[info/healthcheck/.bashrc] gem not installed."
# fi

# -- wasmer
if test -z "$WASMER_DIR"; then
  export WASMER_DIR="$HOME/.wasmer"
  export WASMER_CACHE_DIR="$WASMER_DIR/cache"
  export PATH="$WASMER_DIR/bin:$PATH:$WASMER_DIR/globals/wapm_packages/.bin"
fi

# -- rust sccache
if test -z "$RUSTC_WRAPPER_INIT"; then
  # TODO
  if test 0 = 1; then
    export RUSTC_WRAPPER_INIT=1
    export SCCACHE_REDIS_PORT=6982
    export SCCACHE_REDIS=redis://localhost:$SCCACHE_REDIS_PORT
    if test -z "$RUSTC_WRAPPER"; then
      if command -v sccache >/dev/null 2>&1; then
        export RUSTC_WRAPPER="$(which sccache)"
      else
        echo "[info/healthcheck/.bashrc] sccache not installed."
      fi
    fi
  fi
fi


# -- opam TODO
# $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
# if command -v opam >/dev/null 2>&1; then
#   eval `opam env`
# else
#   echo "[info/healthcheck/.bashrc] opam not installed."
# fi

# -- deno
if test -z "$DENO_INSTALL"; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

# -- pyenv
if test -z "$PYENV_ROOT"; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

# TODO: too slow
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# else
#   echo "[info/healthcheck/.bashrc] pyenv not installed."
# fi

# -- gpg
export GPG_TTY="$(tty)"

# -- fd
if ! command -v fd >/dev/null 2>&1; then
  if command -v fdfind >/dev/null 2>&1; then
    alias fd=fdfind
  fi
fi

# -- fzf
if type fd >/dev/null 2>&1; then
  export FZF_CTRL_T_COMMAND="fd --search-path=\"\$dir\" --hidden --absolute-path"
else
  echo "[info/healthcheck/.bashrc] fd not installed."
fi

# -- ssh-agent
# eval `ssh-agent`
# ssh-add

# -- docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
if test "$LUMA_SET_UID" = 1; then
  export UID="$(id -u)" || true
  export GID="$(id -g)" || true
  export UID_GID="$(id -u):$(id -g)" || true
fi

# -- tmux and fish
if test "$LUMA_AUTO_TMUX" = 1; then
  if [[ -z $TMUX ]] ; then
    # gpg-agent --daemon --allow-preset-passphrase
    command -v fish >/dev/null 2>&1 >/dev/null \
      && command -v tmux >/dev/null 2>&1 >/dev/null \
      && exec tmux
    return
  else
    echo "[info/.bashrc] tmux is running: \$TMUX=$TMUX"
  fi
fi

# tfenv
if test -z "$TFENV_DIR"; then
  export TFENV_DIR="$HOME/.tfenv"
  export PATH="$TFENV_DIR/bin:$PATH"
  if ! test -d "$TFENV_DIR"; then
    echo "[info/healthcheck/.bashrc] tfenv not installed."
  fi
fi

# dvm
if test -z "$DVM_DIR"; then
  export DVM_DIR="$HOME/.dvm"
  export PATH="$DVM_DIR/bin:$PATH"
  if ! test -d "$DVM_DIR"; then
    echo "[info/healthcheck/.bashrc] dvm not installed."
  fi
fi

# volta
if test -z "$VOLTA_HOME"; then
  export VOLTA_HOME="$HOME/.volta"
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

# bit
if test -z "$BIT_HOME"; then
  export BIT_HOME="$HOME/bin"
  export PATH="$BIT_HOME:$PATH"
fi


# serverless
if test -z "$SERVERLESS_DIR"; then
  export SERVERLESS_DIR="$HOME/.serverless/bin"
  export PATH="$SERVERLESS_DIR:$PATH"
fi

# bun
if test -z "$BUN_INSTALL"; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH=$BUN_INSTALL/bin:$PATH
fi

# -- browser
# used by, for example gh cli
if command -v wslview >/dev/null 2>&1; then
  export BROWSER=wslview
fi

# terraform completion
complete -C /usr/bin/terraform terraform

# wasmer
# if ! command -v wasmer >/dev/null; then
#   export WASMER_DIR="$HOME/.wasmer"
#   if test -s "$WASMER_DIR/wasmer.sh"; then
#     source "$WASMER_DIR/wasmer.sh"
#   else
#     echo "[info/healthcheck/.bashrc] wasmer not found."
#   fi
# fi

if [[ -z $NO_FISH ]] ; then
  export NO_FISH=
  command -v fish >/dev/null 2>&1 \
    && exec fish
  return
fi

source "$HOME/dotfiles/common/bash_aliases.sh"
source "$HOME/dotfiles/common/bash_functions.sh"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

return
