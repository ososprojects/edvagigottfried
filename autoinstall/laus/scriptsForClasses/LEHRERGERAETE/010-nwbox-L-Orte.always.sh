#!/bin/sh

# Skript nwbox-L-Orte-always.sh

mkdir -p /nwbox/bilder-neu
mkdir -p /nwbox/manuals-lehrer
mkdir -p /nwbox/videos-neu
mkdir -p /nwbox/jahresbericht
chmod 777 /nwbox
chmod 777 /nwbox/*

OPTIONS='credentials=/root/credentials.nwbox,nobrl,port=139,netbiosname='$(hostname)

# mappings für Lehrergeräte
mount.cifs //smb01/bilder-neu     /nwbox/bilder-neu -o $OPTIONS,rw
mount.cifs //smb01/manuals-lehrer /nwbox/manuals-lehrer -o $OPTIONS,ro
mount.cifs //smb01/videos-neu     /nwbox/videos-neu -o $OPTIONS,rw
mount.cifs //smb01/jahresbericht  /nwbox/jahresbericht -o $OPTIONS,rw

ln -s /nwbox/bilder-neu      "/Orte/6. Bilder (neu)"
ln -s /nwbox/manuals-lehrer  "/Orte/7. Videos (neu)"
ln -s /nwbox/videos-neu      "/Orte/8. Manuals (Lehrer)"
ln -s /nwbox/jahresbericht   "/Orte/9. Jahresbericht"

exit 1
