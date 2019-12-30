echo '.bash_aliases'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias ls='ls --color=auto --show-control-chars --time-style=long-iso -FH'
alias ll='ls -lA'
alias la='ls -A'

alias relogin='exec $SHELL -l'
alias re=relogin

alias c=clear
alias cls=reset

alias df='df -h'
alias du='du -h'
alias du1='du -d1'

export GREP_OPTINS="--color=auto"


function wincmd()
{
    CMD=$1
    shift
    $CMD $* 2>&1 | iconv -f CP932 -t UTF-8
}
alias cmd='winpty cmd'
alias pwsh='winpty powershell'
alias ipconfig='wincmd ipconfig'
alias netstat='wincmd netstat'
alias netsh='wincmd netsh'
alias ping='wincmd /c/windows/system32/ping'

