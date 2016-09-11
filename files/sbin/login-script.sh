#!/bin/sh

timeout1=0
while [ ! -e /nwbox/public/ibinda.public ]
do
  sleep 1
  timeout1=$(($timeout1+1))
  if [ $timeout1 -ge 120 ]
  then
    echo "no net" > /var/log/timeout-net.log
    exit 0
  fi
done

date > /var/log/time-login.log
echo $timeout1 >> /var/log/time-login.log

exit 0
