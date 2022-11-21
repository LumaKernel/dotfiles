function filebrowse
  set -l args $argv
  if test (count $args) = 0
    set args "."
  end
  filebrowser -p 9100 -a 0.0.0.0 -r --noauth $args
end
