#!/bin/sh

timeout1=0
while [ ! -e /nwbox/public/start-from-serverx ]
do
   sleep 1
   timeout1=$(($timeout1+1))
   if [ $timeout1 -ge 60 ]
   then
      echo "start-from-serverx, no public" > /var/log/no-public.txt
      exit 0
   fi
done

echo $timeout1 > /var/log/upstart/timeout-serverx.log

/nwbox/public/start-from-serverx

exit 0

