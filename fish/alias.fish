
echo "fish/alias.fish"

set -e NO_FISH

alias ls='ls --color=auto --show-control-chars --time-style=long-iso -FH -A'
alias ll='ls -lA'

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

# -- vim
alias vi="vim -u NONE"
alias g+='g++ -Wall -Wextra -Wpedantic -fsanitize=undefined -g'
alias vim="nvim"

# -- man
function man_vim
  vim "+runtime! ftplugin/man.vim | Man $argv | only"
end
alias man=man_vim

# -- git
alias gs="git status --short"
alias gsta="git status"
alias gp="git push"
alias ga="git add ."
alias gc="git commit -m"
alias gl="git lg"

# ---- thefuck
thefuck --alias | source
alias nyan=fuck


# ---- trans
alias trans2ja="trans -t ja --shell --brief"
alias trans2en="trans -t en --shell --brief"
