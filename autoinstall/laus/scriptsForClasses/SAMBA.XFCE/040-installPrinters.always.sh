#!/bin/bash

timeout1=0
while lpstat -r | grep -q "not running" > /dev/null
do
   sleep 1
   timeout1=$(($timeout1+1))
   if [ $timeout1 -ge 60 ]
   then
      echo "no cups" > /var/log/cupsrunning.txt
      exit 0
   fi
done

### alle Drucker entfernen
 /usr/sbin/lpadmin -x LJ4000
 /usr/sbin/lpadmin -x LJ2200
 /usr/sbin/lpadmin -x HL5350
 /usr/sbin/lpadmin -x Bibliothek
 /usr/sbin/lpadmin -x LJ4000-EDV1
 /usr/sbin/lpadmin -x HL5340-EDV2
 /usr/sbin/lpadmin -x CANON-BE

# Drucker installieren

### sleep 5
# echo $(date) > /var/log/server-drucker.txt

case $(hostname) in
  r407*)
    /usr/sbin/lpadmin -p LJ4000 -v smb://smb01/LJ4000-EDV1 -P /nwbox/public/ppd/lj4000.ppd -E
    /usr/sbin/lpadmin -d LJ4000
  ;;
  r408*)
    /usr/sbin/lpadmin -p HL5340-EDV2 -v smb://smb01/HL5340D-EDV2 -P /nwbox/public/ppd/hl5340-edv2.ppd -E
    /usr/sbin/lpadmin -d HL5340-EDV2
  ;;
  r110* | r007pc01 | r102pc01 | r210* | r310* )
    /usr/sbin/lpadmin -p HL5350 -v smb://smb01/HL5350 -P /nwbox/public/ppd/hl5350.ppd -E
    /usr/sbin/lpadmin -p LJ2200 -v smb://smb01/LJ2200 -P /nwbox/public/ppd/lj2200d.ppd -E
    /usr/sbin/lpadmin -p Bibliothek -v smb://smb01/bibfarbe -P /nwbox/public/ppd/bibfarbe.ppd -E
    /usr/sbin/lpadmin -d HL5350
  ;;
  r007* )
    /usr/sbin/lpadmin -p LokalerDrucker -v parallel:/dev/lp0 -P /nwbox/public/ppd/hl1250.ppd -E
    /usr/sbin/lpadmin -p HL5350 -v smb://smb01/HL5350 -P /nwbox/public/ppd/hl5350.ppd -E
    /usr/sbin/lpadmin -p LJ2200 -v smb://smb01/LJ2200 -P /nwbox/public/ppd/lj2200d.ppd -E
    /usr/sbin/lpadmin -p Bibliothek -v smb://smb01/bibfarbe -P /nwbox/public/ppd/bibfarbe.ppd -E
    /usr/sbin/lpadmin -d LokalerDrucker
  ;;
  r009* )
    /usr/sbin/lpadmin -p Bibliothek -v smb://smb01/bibfarbe -P /nwbox/public/ppd/bibfarbe.ppd -E
    /usr/sbin/lpadmin -d Bibliothek
  ;;
esac

exit 1
