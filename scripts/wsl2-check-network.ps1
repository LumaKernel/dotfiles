# https://github.com/microsoft/WSL/issues/4150

$remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( $found ){
  $remoteport = $matches[0];
} else{
  echo "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

$addr='0.0.0.0';

echo "addr: $addr"
echo "remoteport: $remoteport"

write-host "Press any key to continue..."
[void][System.Console]::ReadKey($true)
