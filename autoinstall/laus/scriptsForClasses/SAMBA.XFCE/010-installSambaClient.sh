#! /bin/sh

# Skript samba-client-config

### verschoben in XUBUNTU
### useradd -m -b /home -p `openssl passwd -1 123` -u 5555 -s /bin/bash nwboxuser
### echo "123\n123\n" | smbpasswd -s -a nwboxuser
# mkdir -p /home/nwboxuser
chown -R nwboxuser:nwboxuser /home/nwboxuser

mkdir -p /nwbox
mkdir -p /nwbox/Faecher
mkdir -p /nwbox/apps-wine
mkdir -p /nwbox/austausch
mkdir -p /nwbox/bilder
mkdir -p /nwbox/bilder-neu
mkdir -p /nwbox/fueralle
mkdir -p /nwbox/homes-m
mkdir -p /nwbox/linuxapps
mkdir -p /nwbox/manuals
mkdir -p /nwbox/manuals-lehrer
mkdir -p /nwbox/public
mkdir -p /nwbox/vcds
mkdir -p /nwbox/vcd2
mkdir -p /nwbox/vcd3
mkdir -p /nwbox/videos
mkdir -p /nwbox/videos-neu
chmod -R 777 /nwbox

cp -p /nwbox-nfs/files/credentials.nwbox /root
chown root:root /root/credentials.nwbox
chmod 600 /root/credentials.nwbox

# for smb printers
apt-get install -y smbclient
