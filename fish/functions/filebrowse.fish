function filebrowse
  echo "username: admin; password: admin"
  set -l args $argv
  if test (count $args) = 0
    set args "."
  end
  filebrowser -p 9100 -a 0.0.0.0 -r $args
end
