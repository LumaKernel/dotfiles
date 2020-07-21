
echo "fish/alias.fish"

set -e NO_FISH

switch (uname)
  case Linux
    functions --copy ls standard_ls
    function ls
      command -v exa >/dev/null 2>/dev/null
        and exa --all $argv
        or standard_ls --color=auto --show-control-chars --time-style=long-iso -FH -A $argv
    end
    function ll
      command -v exa >/dev/null 2>/dev/null
        and exa --tree --long --all --level 1 $argv
        or ls -lA $argv
    end
end


function relogin
  deactivate_venv
  exec /bin/bash
end
alias re=relogin

alias bash='set -x NO_FISH 1; /bin/bash'

alias c 'clear; tmux clear-history'

alias df='df -h'
alias du='du -h'
alias du1='du -d1'

alias grep='grep --color'

function rm
  echo "rm is disabled, use trash or /bin/rm instead."
end

# -- vim
alias v="/usr/bin/vim"
alias vi="nvim -u NONE"
alias vim="nvim"

# -- c++
alias g+='g++ -Wall -Wextra -Wpedantic -fsanitize=undefined -g'

# -- man
function man_vim
  vim "+runtime! ftplugin/man.vim | Man $argv | only"
end
alias man=man_vim


# -- open-browser
function open-browser
  set OPEN_BROWSER_PATH ~/.cache/dein/repos/github.com/tyru/open-browser.vim
  nvim -u NONE -i NONE -N -n --headless --cmd "set rtp+=$OPEN_BROWSER_PATH" "+runtime! plugin/openbrowser.vim | sil! OpenBrowser $argv"
end

if [ "$is_WSL" = 1 ]
  alias cdwin='cd $WinHome'
  alias open=open-browser
end

# -- git
alias gs="git status --short"
alias gp="git push"
alias ga="git add"
alias gc="git commit"
alias gl="git lg"

# -- ocaml
alias ocamlrepl="rlwrap ocaml"

#
alias checkhealth="nvim +checkhealth"

alias p="pet exec"


function garbage-collect-tmux
  tmux ls | sed -n '/(attached)$/!s/\([^:]\+\):.*/\1/p' | xargs -I {} tmux kill-ses -t"{}"
end

function dein
  set where (find ~/.cache/dein/repos/ -mindepth 3 -maxdepth 3 -type d | fzf --reverse)
  if [ -n "$where" ]
    cd $where
  end
end

if [ "$is_WSL" = 1 ]
  # here
  alias h "explorer.exe ."
end
