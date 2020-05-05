# 参考
# /etc/skel/.bashrc
# http://www.unixuser.org/~euske/doc/bashtips/bashrc.html

# echo ".bashrc:$$:`whoami`:`tput cols`:`tput lines`:$BASH_SOURCE:$PATH" >> ~/.log
# echo "----" >> ~/.log
# ps xao pid,ppid,cmd >> ~/.log
# echo "----" >> ~/.log
# case $- in
#     *i*) ;;
#       *) return;;
# esac
# echo "::interactive" >> ~/.log
# return


# インタラクティブではない場合，終了
case $- in
    *i*) ;;
      *) return;;
esac
  echo '.bashrc'
  echo '    - for Ubuntu'

# ---- vim の環境変数を削除
unset VIM
unset VIMRUNTIME
unset MYVIMRC
unset MYGVIMRC


# TODO: どうにかする
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi



# ---- パスを追加
# pip のライブラリなど
export PATH=~/.local/bin:$PATH
export PATH=$PATH:$HOME/shell-tools


[ -f "${HOME}/dotfiles/linux/.bash_aliases" ] && source "${HOME}/dotfiles/linux/.bash_aliases"
[ -f "${HOME}/dotfiles/linux/.bash_functions" ] && source "${HOME}/dotfiles/linux/.bash_functions"


# ヒストリーをファイルに保存
shopt -s histappend
HISTCONTROL=ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s dirspell  # 存在しないディレクトリ名の時に補完
shopt -s globstar  # ** が再帰的になる
shopt -s cdspell  # cd の小さなスペルミスを修正
shopt -s checkwinsize  # ${COLUMNS} と ${LINES} を winsize に同期
shopt -s no_empty_cmd_completion  # 何も入力してないなら補完しない
shopt -s nocaseglob  # glob で ignorecase


# ---- hisotry 向上

# i: 直前の履歴 30件を表示する。引数がある場合は過去 1000件を検索
function i {
    if [ "$1" ]; then history 1000 | grep "$@"; else history 30; fi
}

# I: 直前の履歴 30件を表示する。引数がある場合は過去のすべてを検索
function I {
    if [ "$1" ]; then history | grep "$@"; else history 30; fi
}


# ---- Powerline Shell
#   pip3 install powerline-shell

command -v powerline-shell >/dev/null 2>&1
if (( ! $? )) ; then

  function _update_ps1() {
    PS1=$(powerline-shell $?)
  }

  if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
  fi

fi

# ---- colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# ---- fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='fd --hidden --exclude ".git"'
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


# ---- nvm
export NVM_DIR="$HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ---- cquery
command -v cquery >/dev/null 2>&1 ||
  export PATH=$PATH:$HOME/bin/cquery/build/release/bin


# ---- themis
command -v themis >/dev/null 2>&1 ||
  export PATH=$PATH:$HOME/.cache/dein/repos/github.com/thinca/vim-themis/bin


# ---- bashmarks
[ -f "${HOME}/.local/bin/bashmarks.sh" ] && source "${HOME}/.local/bin/bashmarks.sh"


# ---- user installed bin
export PATH=$PATH:$HOME/bin


# ---- cargo
export PATH=$PATH:$HOME/.cargo/bin


# ---- delete my fish envs
export fish_key_bindings=
export fish_bind_mode=


# ---- dircolors
eval $(dircolors "$HOME/dotfiles/.dircolors")


# --
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)

test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)


# -- WSL
uname -a 2>/dev/null | grep microsoft >/dev/null 2>/dev/null
if (( ! $? )); then
  export is_WSL=1
fi

# Related: https://github.com/mintty/wsltty/issues/197
if [[ -n "$is_WSL" ]]; then
  command -v cmd.exe >/dev/null 2>&1 \
    || return
fi

if [[ -n "$is_WSL" ]] && command -v wslpath >/dev/null 2>/dev/null; then
  echo '    - cdwin : Go to win home.'
  [[ -z "$WinUserName" ]] && export WinUserName="$(cmd.exe /c echo %UserName% 2>/dev/null | tr -d '\n' | tr -d '\r')"
  [[ -z "$WinHome" ]] \
    && export WinHome="$(wslpath c:/users/$WinUserName)"
  alias cdwin="cd $WinHome"
fi

# -- go
export PATH=/usr/local/go/bin:$PATH
export GOPATH=$HOME/go
export PATH=$HOME/go/bin:$PATH

# -- gem
if command -v gem >/dev/null 2>&1; then
  export PATH="$(gem environment gemdir)/bin":$PATH
fi

# -- opam TODO
# $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
# eval `opam env`

# -- tmux and fish
if [[ -z $TMUX ]] ; then
  export RUN_VIM=1
  command -v fish >/dev/null 2>&1 >/dev/null \
    && command -v tmux >/dev/null 2>&1 >/dev/null \
    && exec tmux
  return
else
  echo tmux is running: \$TMUX=$TMUX
fi

if [[ -z $NO_FISH ]] ; then
  export NO_FISH=
  command -v fish >/dev/null 2>&1 \
    && exec fish
  return
fi
