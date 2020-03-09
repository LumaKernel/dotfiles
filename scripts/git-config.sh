#!/bin/bash

git config --global core.ignorecase false
git config --global core.quotepath false
git config --global core.safecrlf true
git config --global core.autocrlf false
# git config --global url."git@github.com:".insteadOf "https://github.com/"

git config --global core.excludesfile ~/.gitignore_global


# https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs

git config --global alias.lg "!git lg1"
git config --global alias.lg1 !"git lg1-specific --all"
git config --global alias.lg2 !"git lg2-specific --all"
git config --global alias.lg3 !"git lg3-specific --all"

git config --global alias.lg1-specific "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
git config --global alias.lg2-specific "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
git config --global alias.lg3-specific "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'"
