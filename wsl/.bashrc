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
echo '- cdwin : Go to win home.'

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


case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


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
if [[ -n $? ]] ; then

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


# -- WSL 特有の設定

export WinUserName=`cmd.exe /c echo %UserName% 2>/dev/null`
export WinHome="/mnt/c/Users/$WinUserName"
alias cdwin="cd $WinHome"


