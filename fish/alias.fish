
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
function v
  eval (which vim) $argv
end
alias vi="nvim -u NONE"
alias vim="nvim"

# -- c++
alias g+='g++ -Wall -Wextra -Wpedantic -fsanitize=undefined -g'

# -- man
function man_vim
  vim "+runtime! ftplugin/man.vim | Man $argv | only"
end
alias man=man_vim

# -- eslint watch

function esw-here
  npx -p eslint-watch esw . --ext .js,.ts,.tsx,.json -w --changed --fix-dry-run
end


# # -- open-browser
# function open-browser
#   set OPEN_BROWSER_PATH ~/.cache/dein/nvim/repos/github.com/tyru/open-browser.vim
#   nvim -u NONE -i NONE -N -n --headless --cmd "set rtp+=$OPEN_BROWSER_PATH" "+runtime! plugin/openbrowser.vim | sil! OpenBrowser $argv"
# end
# 
# if [ "$is_WSL" = 1 ]
#   alias cdwin='cd $WinHome'
#   alias open=open-browser
# end

# -- browser
# used by, for example gh cli
export BROWSER=wslview

# -- git
alias gs="git status --short"
alias gp="git push"
alias ga="git add"
alias gc="git commit"
alias gl="git lg"

# -- ocaml
alias ocamlrepl="rlwrap ocaml"
alias replocaml="rlwrap ocaml"

# -- some
alias checkhealth="nvim +checkhealth"
alias p="pet exec"
alias repl="rlwrap"
alias dk="docker"
alias dc="docker-compose"
alias dce="docker-compose exec"

alias tf="terraform"

function dcc
  repl docker-compose exec "$argv" /bin/bash
end


function garbage-collect-tmux
  tmux ls | sed -n '/(attached)$/!s/\([^:]\+\):.*/\1/p' | xargs -I {} tmux kill-ses -t"{}"
end

function dein
  set where (find ~/.cache/dein/nvim/repos/ -mindepth 3 -maxdepth 3 -type d | fzf --reverse)
  if [ -n "$where" ]
    cd $where
  end
end

if [ "$is_WSL" = 1 ]
  # here
  alias h "explorer.exe ."
end

function git-prune-trackings
  git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 (git branch -vv | grep origin | psub) | awk '{print $1}' | xargs git branch -d
end

function hist-ranking-all
  history | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 30
end

function hist-ranking-1000
  history | head -n 1000 | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 30
end

alias rakning-hist-all=hist-ranking-all
alias rakning-hist-1000=hist-ranking-1000


function nvim-reload
  nvim +"call dein#recache_runtimepath()" +qa!
  and nvim +":UpdateRemotePlugins" +qa!
end

function nvim-bench
  nvim +"call dein#recache_runtimepath()" +qa!
  and nvim +":UpdateRemotePlugins" +qa!
  begin
    set -l sum 0
    set -l T 10
    for i in (seq 1 $T)
      /bin/rm -f /tmp/nvim-startuptime
      nvim +"autocmd VimEnter * qa!" --startuptime /tmp/nvim-startuptime
      set -l this (cat /tmp/nvim-startuptime | tail -n 1 | awk '{print $1}')
      echo $i: $this ms
      set sum (math -- $sum + $this)
      /bin/rm -f /tmp/nvim-startuptime
    end
    echo Mean Time: (math -- $sum / $T) ms
  end
end

function rm_node_modules
  /bin/rm -r ./node_modules
end

function ffm
  docker run --rm -it -v "$PWD":/tmp/h -w "/tmp/h" jrottenberg/ffmpeg "$argv"
end

function ffp
  docker run -it --rm -v "$PWD":/tmp/h -w "/tmp/h" sjourdan/ffprobe "$argv"
end

function nvim-plug-here
  nvim --cmd "let &rtp = &rtp .. ',' .. expand('%:h:p')" "$argv"
end

function nvim-only-here
  nvim -u DEFAULTS --cmd "let &rtp = expand('%:h:p') .. ',' .. &rtp" "$argv"
end

function node-generate-password
  node -e "require('crypto').randomBytes(48, function(err, buffer) { var token = buffer.toString('hex'); console.log(token); });"
end

function node-use-port
  node -e "[3000,8000].forEach(async(p)=>{try{await new Promise((rs,rj)=>require('http').createServer().listen(p,void 0,rs).on('error',rj));console.log(`\${p}: listening`)}catch{console.log(`\${p}: already used`)}})"
end
