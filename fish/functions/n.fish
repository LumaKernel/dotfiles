function n
  date
  time $argv
  echo_and_notify (string replace -a " " _ "$status  $argv")
  date
end
