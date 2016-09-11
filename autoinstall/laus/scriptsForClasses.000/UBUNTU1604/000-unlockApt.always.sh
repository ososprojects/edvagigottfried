#! /bin/bash

rm /var/lib/dpkg/updates/*
rm /var/lib/dpkg/lock
dpkg --configure -a
apt-get -f install

exit 1
