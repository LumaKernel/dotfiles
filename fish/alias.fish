
echo "fish/alias.fish"

set -e NO_FISH

switch (uname)
  case Linux
    alias ls='ls --color=auto --show-control-chars --time-style=long-iso -FH -A'
    alias ll='ls -lA'
end


function relogin
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
alias vi="vim -u NONE"
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
alias open=open-browser

# -- git
alias gs="git status --short"
alias gsta="git status"
alias gp="git push"
alias ga="git add ."
alias gc="git commit -m"
alias gl="git lg"

# -- trans
alias trans2ja="trans -t ja --shell --brief"
alias trans2en="trans -t en --shell --brief"

# -- ocaml
alias ocamlrepl="rlwrap ocaml"

