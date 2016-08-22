#!/bin/sh

export DISPLAY=:0.0
export XAUTHORITY=/home/nwboxuser/.Xauthority


# Bei Klick auf 'herunterfahren' (res=1) oder ohne Klick (res=5) wird der PC heruntergefahren.
# Bei Klick auf 'weiterarbeiten' (res=0) geschieht nichts.
# ACHTUNG! Cancel- und Ok-Button wurden vertauscht, damit der Default-Knopf (Druck auf Enter-Taste) 'weiterarbeiten' ist.

chvt 7
zenity --question --timeout 10 --text='Der PC fährt in 10 Sekunden herunter. Was wollen Sie tun?' --title='Shutdown' \
  --ok-label='weiterarbeiten' --cancel-label='herunterfahren'
res=$?

case $res in
  1 | 5)
#    vboxmanage controlvm Win7 poweroff
    sudo shutdown -h -P now
  ;;
  *)
  ;;
esac

exit 0

