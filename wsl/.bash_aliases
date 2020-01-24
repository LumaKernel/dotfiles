echo '.bash_aliases'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias ls='ls --color=auto --show-control-chars --time-style=long-iso -FH'
alias ll='ls -lA'
alias la='ls -A'
alias l='ls -CF'

alias relogin='exec $SHELL -l'
alias re=relogin

alias c=clear

alias df='df -h'
alias du='du -h'
alias du1='du -d1'

export GREP_OPTINS="--color=auto"

alias vi="vim -u NONE"
alias g+='g++ -Wall -Wextra -Wpedantic -fsanitize=undefined -g'
alias vi='vim -u NONE'

