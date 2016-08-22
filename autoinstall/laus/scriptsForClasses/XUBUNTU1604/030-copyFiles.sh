#!/bin/sh

# only one time

# autologin etcc.
# echo "autologin-user=nwboxuser" >> /etc/lightdm/lightdm.conf.d/10-xubuntu.conf
cp -Rp /nwbox-nfs/files/etc/* /etc
cp -Rp /nwbox-nfs/files/var/* /var

# scripts
cp -up /nwbox-nfs/files/sbin/* /usr/local/sbin
chmod 777 /usr/local/sbin/*

### cp -R /nwbox-nfs/files/var/lib/AccountsService /var/lib

# Boole
# mkdir -p /home/nwboxuser/Boole
# cp -Rp /nwbox-nfs/files/boole/* /home/nwboxuser/Boole

# mkdir -p /home/nwboxuser/.mozilla/firefox
# cp -Rp /nwbox-nfs/files/firefox/* /home/nwboxuser/.mozilla/firefox

# mkdir -p /home/nwboxuser/.PlayOnLinux/shortcuts
# cp -p /nwbox-nfs/files/shortcuts/* /home/nwboxuser/.PlayOnLinux/shortcuts
