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

# git push --force を弱めた版， ローカルのほうが新しい場合のみ
git config --global alias.please "push --force-with-lease"
git config --global alias.commend 'commit --amend --no-edit'
git config --global alias.it '!git init && git commit -m “root” --allow-empty'

$ git config --global alias.stsh 'stash --keep-index'
$ git config --global alias.staash 'stash --include-untracked'
$ git config --global alias.staaash 'stash --all'

# git stsh      # stash only unstaged changes to tracked files
# git stash     # stash any changes to tracked files
# git staash    # stash untracked and tracked files
# git staaash   # stash ignored, untracked, and tracked files

git config --global alias.merc 'merge --no-ff'

