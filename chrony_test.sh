#!/bin/bash
#
# Uses ntpdate to query status of ntp server
# then issues chronyc command inside container to check status
#

imagename="docker-chrony-alpine"

# ntpdate needs to be installed
ntpdate_path=$(which ntpdate)
if [ -z "$ntpdate_path" ]; then
  echo "ERROR could not find ntpdate, try 'sudo apt-get install ntpdate'"
  exit 3
fi

echo ""
echo "=== CHECK LOCAL 123/udp port ====================="
ntpdate -q 127.0.0.1


echo ""
echo "=== CHECK inside container ====================="
docker exec -it $imagename /bin/ash -c 'chronyc tracking'
