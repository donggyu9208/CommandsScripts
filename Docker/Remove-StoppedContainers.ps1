docker ps -a -q | % { docker rm $_ }
