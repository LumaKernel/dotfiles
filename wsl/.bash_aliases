echo '.bash_aliases'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'
alias ~='cd ~'

alias ls='ls --color=auto --show-control-chars --time-style=long-iso -FH -A'
alias ll='ls -lA'
alias l='ls -CF'

alias relogin='exec $SHELL -l'
alias re=relogin

alias c=clear

alias df='df -h'
alias du='du -h'
alias du1='du -d1'

alias grep='grep --color'

# -- vim
alias vi="vim -u NONE"
alias g+='g++ -Wall -Wextra -Wpedantic -fsanitize=undefined -g'
alias vim="nvim"

# -- man
man_vim() { vim "+runtime! ftplugin/man.vim | Man $* | only"; }
alias man=man_vim

# -- git
alias gs="git status --short"
alias gsta="git status"
alias gp="git push"
alias ga="git add ."
alias gc="git commit -m"

