#!/bin/sh

rm -Rf /nwboxuser-rw

mkdir -p /nwboxuser-rw
chown nwboxuser:nwboxuser /nwboxuser-rw
chmod 777 /nwboxuser-rw

mkdir -p /nwboxuser-work
chown nwboxuser:nwboxuser /nwboxuser-work
chmod 777 /nwboxuser-work

# mount -t overlayfs overlayfs -o upperdir=/nwboxuser-rw,lowerdir=/opt/nwboxuser,workdir=/nwboxuser-work /home/nwboxuser
# mount -t overlayfs overlayfs -o upperdir=/nwboxuser-aufs,lowerdir=/opt/nwboxuser /home/nwboxuser
# mount --bind /opt/nwboxuser/Schreibtisch /opt/nwboxuser/dt-main
mount -t aufs -o dirs=/nwboxuser-rw:/opt/nwboxuser -o udba=reval none /home/nwboxuser

exit 1
