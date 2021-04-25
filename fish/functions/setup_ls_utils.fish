function setup_ls_utils
  if test -z "$LUMA_WORLD_SETUP_LS_UTILS"
    set -g LUMA_WORLD_SETUP_LS_UTILS 1
    switch (uname)
      case Linux
        function ls
          command -v exa >/dev/null 2>/dev/null
            and exa --all $argv
            or /bin/ls --color=auto --show-control-chars --time-style=long-iso -FH -A $argv
        end
        function ll
          command -v exa >/dev/null 2>/dev/null
            and exa --tree --long --all --level 1 $argv
            or /bin/ls -lA $argv
        end
    end
  end
end
