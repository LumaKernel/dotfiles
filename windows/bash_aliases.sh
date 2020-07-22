#!/bin/bash

echo 'windows/bash_aliases.sh'

source "${HOME}/dotfiles/common/bash_aliases.sh"

# -- windows
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
