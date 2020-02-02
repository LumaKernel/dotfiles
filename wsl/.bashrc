# 参考
# /etc/skel/.bashrc
# http://www.unixuser.org/~euske/doc/bashtips/bashrc.html


# -- WSL と Linux 共通，後で分けるかも

# インタラクティブではない場合，終了
case $- in
    *i*) ;;
      *) return;;
esac

echo '.bashrc'
echo '    - for WSL'
echo '    - cdwin : Go to win home.'


# ---- vim の環境変数を削除
unset VIM
unset VIMRUNTIME
unset MYVIMRC
unset MYGVIMRC


# ---- パスを追加
# pip のライブラリなど
export PATH=$PATH:~/.local/bin


[ -f "${HOME}/dotfiles/wsl/.bash_aliases" ] && source "${HOME}/dotfiles/wsl/.bash_aliases"

[ -f "${HOME}/dotfiles/wsl/.bash_functions" ] && source "${HOME}/dotfiles/wsl/.bash_functions"

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

# ---- less
export LESS='-R --no-init -g -j10 --quit-if-one-screen'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'


# ---- nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ---- cquery
command -v cquery >/dev/null 2>&1 ||
  export PATH=$PATH:$HOME/bin/cquery/build/release/bin


# ---- thefuck
eval $(thefuck --alias) >/dev/null 2>&1
alias nyan=fuck


# ---- themis
command -v themis >/dev/null 2>&1 ||
  export PATH=$PATH:$HOME/.cache/dein/repos/github.com/thinca/vim-themis/bin


# ---- bashmarks
[ -f "${HOME}/.local/bin/bashmarks.sh" ] && source "${HOME}/.local/bin/bashmarks.sh"


# ---- user installed bin
export PATH=$PATH:$HOME/bin



# -- WSL 特有の設定

which cmd.exe >/dev/null 2>&1
if (( ! $? )); then
  export is_WSL=1
fi

if [[ $is_WSL ]]; then
  export WinUserName=`cmd.exe /c echo %UserName% 2>/dev/null | tr -d '\n' | tr -d '\r'`
  export WinHome="/mnt/c/Users/$WinUserName"
  alias cdwin="cd $WinHome"
fi

