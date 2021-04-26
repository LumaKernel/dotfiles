function garbage_collect_tmux
  tmux ls | sed -n '/(attached)$/!s/\([^:]\+\):.*/\1/p' | xargs -I {} tmux kill-ses -t"{}"
end
