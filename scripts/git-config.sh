#!/bin/bash

git config --global core.ignorecase false
git config --global core.quotepath false
git config --global core.safecrlf true
git config --global core.autocrlf false
# git config --global url."git@github.com:".insteadOf "https://github.com/"

git config --global core.excludesfile ~/.gitignore_global

git config --global url."git@github.com:".pushInsteadOf "https://github.com/"
git config --global url."git@gitlab.com:".insteadOf "https://gitlab.com/"

git config --global gc.pruneExpire "2.month.ago"

git config --global core.editor nvim

git config --global blame.ignoreRevsFile .git-blame-ignore-revs

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

git config --global alias.stsh 'stash --keep-index'
git config --global alias.staash 'stash --include-untracked'
git config --global alias.staaash 'stash --all'

# git stsh      # stash only unstaged changes to tracked files
# git stash     # stash any changes to tracked files
# git staash    # stash untracked and tracked files
# git staaash   # stash ignored, untracked, and tracked files

git config --global alias.rui 'range-diff @{u} HEAD@{1} @'

git config --global alias.merc 'merge --no-ff'

git config --global alias.me !'git config --list | grep "^user\\."'
git config --global alias.dish "diff --cached"

git config --global alias.dif "diff --ignore-all-space"
git config --global alias.dis "diff --cached --ignore-all-space"

echo "[Hint/git-config.sh] 以下を自分で実行してください"
echo "git config --global user.name <name>"
echo "git config --global user.email <email>"
