#!/bin/sh

timeout1=0
while [ ! -e /nwbox/public/ibinda.public ]
do
  sleep 1
  timeout1=$(($timeout1+1))
  if [ $timeout1 -ge 600 ]
  then
    date > /var/log/timeout-net1.log
    echo "no net" >> /var/log/timeout-net1.log
    exit 0
  fi
done

date > /var/log/time-login1.log
echo $timeout1 >> /var/log/time-login1.log

exit 0
