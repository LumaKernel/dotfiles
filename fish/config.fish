
echo "fish/config.fish"

pyenv init - | source

# -- powerline-shell
function fish_prompt
  set -x powerline_fish_key_bindings $fish_key_bindings
  set -x powerline_fish_bind_mode $fish_bind_mode
  powerline-shell --shell bare $status
  set -e powerline_fish_key_bindings
  set -e powerline_fish_bind_mode
end

fish_vi_key_bindings

source ~/dotfiles/fish/alias.fish

# -- ローカルパス
set -x PATH ~/.local/bin $PATH

# XXX: 役立ってるかわからん
set -x GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# -- less
export LESS='-R --no-init -g -j10 --quit-if-one-screen'
export LESSOPEN='| /usr/share/source-highlight/src-hilite-lesspipe.sh %s'

# -- cquery
command -v cquery >/dev/null 2>&1
  and set -x PATH $PATH $HOME/bin/cquery/build/release/bin

# -- themis
command -v themis >/dev/null 2>&1
  and set -x PATH $PATH $HOME/.cache/dein/repos/github.com/thinca/vim-themis/bin

# -- pyenv
command -v pyenv >/dev/null 2>&1
  and source (pyenv init -|psub)

# --
functions --copy cd standard_cd
function cd
  standard_cd $argv; and ls
end

# -- clipboard
if [ $is_WSL = '1' ]
  function fish_clipboard_copy
    set -l cmdline (commandline --current-selection)
    test -n "$cmdline"; or set cmdline (commandline)
    if type -q clip.exe
      printf '%s\n' $cmdline | clip.exe -i
    else if type -q win32yank.exe
      printf '%s\n' $cmdline | win32yank.exe -i
    else if type -q pbcopy
      printf '%s\n' $cmdline | pbcopy
    else if set -q WAYLAND_DISPLAY; and type -q wl-copy
      printf '%s\n' $cmdline | wl-copy
    else if type -q xsel
      # Silence error so no error message shows up
      # if e.g. X isn't running.
      printf '%s\n' $cmdline | xsel --clipboard 2>/dev/null
    else if type -q xclip
      printf '%s\n' $cmdline | xclip -selection clipboard 2>/dev/null
    end
  end

  # Defined in /usr/share/fish/functions/fish_clipboard_paste.fish @ line 1
  function fish_clipboard_paste
    set -l data
    if type -q win32yank.exe
      set data (win32yank.exe -o 2>/dev/null)
    else if type -q pbpaste
      set data (pbpaste 2>/dev/null)
    else if set -q WAYLAND_DISPLAY; and type -q wl-paste
      set data (wl-paste 2>/dev/null)
    else if type -q xsel
      set data (xsel --clipboard 2>/dev/null)
    else if type -q xclip
      set data (xclip -selection clipboard -o 2>/dev/null)
    end
    
    # Issue 6254: Handle zero-length clipboard content
    if not string match -qr . -- "$data"
      return 1
    end
    
    # Also split on \r to turn it into a newline,
    # otherwise the output looks really confusing.
    set data (string split \r -- $data)
    
    # If the current token has an unmatched single-quote,
    # escape all single-quotes (and backslashes) in the paste,
    # in order to turn it into a single literal token.
    #
    # This eases pasting non-code (e.g. markdown or git commitishes).
    if __fish_commandline_is_singlequoted
      if status test-feature regex-easyesc
        set data (string replace -ra "(['\\\])" '\\\\$1' -- $data)
        else
          set data (string replace -ra "(['\\\])" '\\\\\\\$1' -- $data)
        end
    end
    if not string length -q -- (commandline -c)
      # If we're at the beginning of the first line, trim whitespace from the start,
      # so we don't trigger ignoring history.
      set data[1] (string trim -l -- $data[1])
    end
    if test -n "$data"
      commandline -i -- $data

    end
  end
end

# TODO: dircolors は必要？
# TODO: opam env

if test -n "$TMUX" -a -n "$RUN_VIM"
  set -e RUN_VIM
  tmux setenv -r RUN_VIM
  command -v nvim 2>&1 >/dev/null \
    && nvim \
    || vim
end

