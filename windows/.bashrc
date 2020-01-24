# インタラクティブではない場合，終了
case $- in
    *i*) ;;
      *) return;;
esac

echo '.bashrc'

# ---- vim の環境変数を削除
unset VIM
unset VIMRUNTIME
unset MYVIMRC
unset MYGVIMRC



# ---- hisotry 向上

# i: 直前の履歴 30件を表示する。引数がある場合は過去 1000件を検索
function i {
    if [ "$1" ]; then history 1000 | grep "$@"; else history 30; fi
}

# I: 直前の履歴 30件を表示する。引数がある場合は過去のすべてを検索
function I {
    if [ "$1" ]; then history | grep "$@"; else history 30; fi
}



# ---- git の情報を表示
source /c/msys64/usr/share/git/completion/git-prompt.sh
source /c/msys64/usr/share/git/completion/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[32m\]\u@ \[\033[1;33m\]\w\[\033[34m\]$(__git_ps1)\[\033[00m\]'$'\n\$ '


[ -f "${HOME}/dotfiles/windows/.bash_aliases" ] && source "${HOME}/dotfiles/windows/.bash_aliases"

[ -f "${HOME}/dotfiles/windows/.bash_functions" ] && source "${HOME}/dotfiles/windows/.bash_functions"

