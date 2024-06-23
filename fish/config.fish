
echo "[info/enter] fish/config.fish"
set fish_greeting

set -x SHELL_NAME fish
set -e NO_FISH

set -l LOCAL_PROFILE_FILEPATH "$HOME/local_profile.fish"
if test -f "$LOCAL_PROFILE_FILEPATH"
  echo "[info/config.fish/local_profile] $LOCAL_PROFILE_FILEPATH found"
  source "$LOCAL_PROFILE_FILEPATH"
else
  echo "[warn/config.fish/local_profile] $LOCAL_PROFILE_FILEPATH not found"
end

if test -z "$LUMA_WORLD_FISH_FUNCTIONS"
  set -g LUMA_WORLD_FISH_FUNCTIONS "$HOME/dotfiles/fish/functions"
  set -g fish_function_path "$LUMA_WORLD_FISH_FUNCTIONS" $fish_function_path
end

if test -z "$LUMA_WORLD_FISH_COMPLETE"
  set -g LUMA_WORLD_FISH_COMPLETE "$HOME/dotfiles/fish/completions"
  set -g fish_complete_path "$LUMA_WORLD_FISH_COMPLETE" $fish_complete_path
end

set -g fish_key_bindings fish_user_key_bindings

# -- color
set fish_color_command brcyan

# -- powerline-shell
# TODO: slow
# function fish_prompt
#   powerline-shell --shell bare $status
# end

# -- rbenv
# TODO: slow
# if command -v rbenv >/dev/null 2>&1
#   source (rbenv init -|psub)
# else
#   echo "[info/healthcheck/config.fish] rbenv not installed."
# end

if test "$LUMA_IS_MAC" = 1
  alias sed gsed
end

# -- cd improved
functions --copy cd cd_default
function cd
  cd_default $argv; and ls

  test -z "$argv"
    and deactivate_venv

  if test "$NO_AUTO_VENV" != "1"
    activate_venv
  end
end

# hitting empty enter to ls (空エンター)

function done_enter --on-event fish_postexec
  if test -z "$argv"
    ls
    commandline -f force-repaint
    if test "$NO_AUTO_VENV" != "1"
      activate_venv
    end
  end
end

# venv
# TODO: slow
# set -x VIRTUAL_ENV_DISABLE_PROMPT 1
# activate_venv

# tabtab source for packages
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# -- clipboard
if test "$is_WSL" = '1'
  function fish_clipboard_copy
    set -l cmdline (commandline --current-selection)
    test -n $cmdline; or set cmdline (commandline)
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
    if not string match -qr . -- $data
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
