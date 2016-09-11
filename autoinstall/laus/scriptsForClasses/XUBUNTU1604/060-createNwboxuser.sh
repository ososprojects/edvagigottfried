#! /bin/sh

useradd -m -b /home -p `openssl passwd -1 123` -u 5555 -s /bin/bash nwboxuser
echo "123\n123\n" | smbpasswd -s -a nwboxuser

mkdir -p /home/nwboxuser
chown -R nwboxuser:nwboxuser /home/nwboxuser
