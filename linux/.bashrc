# shellcheck shell=bash

# Return if not interactive.
case $- in
    *i*) ;;
      *) return;;
esac

echo "[info/enter] linux/.bashrc"

# ---- dircolors
eval $(dircolors "$HOME/dotfiles/.dircolors")

# -- linuxbrew
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

shopt -s dirspell  # 存在しないディレクトリ名の時に補完
shopt -s globstar  # ** が再帰的になる

# -- WSL
uname -a 2>/dev/null | grep microsoft >/dev/null 2>/dev/null
if (( ! $? )); then
  export is_WSL=1
fi

if [[ -n "$is_WSL" ]] && command -v wslpath >/dev/null 2>/dev/null; then
  echo '    - cdwin : Go to win home.'
  [[ -z "$WinUserName" ]] && export WinUserName="$(wslvar username 2>/dev/null | tr -d '\n' | tr -d '\r')"
  [[ -z "$WinHome" ]] \
    && export WinHome="$(wslpath "c:/users/$WinUserName")"
  alias cdwin="cd $WinHome"
fi


source "${HOME}/dotfiles/common/bashrc.sh"
