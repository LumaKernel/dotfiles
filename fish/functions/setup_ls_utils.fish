function setup_ls_utils
  if test -z "$LUMA_WORLD_SETUP_LS_UTILS"
    set -g LUMA_WORLD_SETUP_LS_UTILS 1
    switch (uname)
      case Linux
        if command -v eza >/dev/null 2>/dev/null
          function ls
            eza --all $argv
          end
          function ll
            eza --tree --long --all --level 1 $argv
          end
        else
          function ls
            /bin/ls --color=auto --show-control-chars --time-style=long-iso -FH -A $argv
          end
          function ll
            /bin/ls -lA $argv
          end
        end
      case Darwin
        if command -v eza >/dev/null 2>/dev/null
          function ls
            eza --all $argv
          end
          function ll
            eza --tree --long --all --level 1 $argv
          end
        else
          function ls
            command ls -G -A $argv
          end
          function ll
            command ls -G -lA $argv
          end
        end
    end
  end
end
