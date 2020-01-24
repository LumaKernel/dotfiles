echo '.bashrc'

unset VIM
unset VIMRUNTIME
unset MYVIMRC
unset MYGVIMRC


source /c/msys64/usr/share/git/completion/git-prompt.sh
source /c/msys64/usr/share/git/completion/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[32m\]\u@ \[\033[1;33m\]\w\[\033[34m\]$(__git_ps1)\[\033[00m\]'$'\n\$ '

if [ -f "${HOME}/dotfiles/windows/.bash_aliases" ]; then
  source "${HOME}/dotfiles/windows/.bash_aliases"
fi

if [ -f "${HOME}/dotfiles/windows/.bash_functions" ]; then
  source "${HOME}/dotfiles/windows/.bash_functions"
fi

