#!/bin/sh

rm /home/nwboxuser/Schreibtisch/*
rm /home/nwboxuser/.config/xfce4/desktop/icons.screen0-*
cp -p /home/nwboxuser/dt-main/* /home/nwboxuser/Schreibtisch
xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -s 60
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s true
xfdesktop --reload

# xfdesktop --quit
# sleep 1
# xfdesktop &

exit 0

rm /opt/nwboxuser.org/Schreibtisch
ln -s /opt/nwboxuser.org/dt-buero/Schreibtisch /opt/nwboxuser.org
xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -s 60
xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-trash -s true
xfdesktop --reload
