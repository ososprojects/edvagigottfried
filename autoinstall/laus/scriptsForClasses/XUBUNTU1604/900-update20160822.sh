#! /bin/bash

exit 1

# vorerst versuchsweise nur für 4 Geräte

export DEBIAN_FRONTEND=noninteractive

rm /var/lib/dpkg/updates/*
rm /var/lib/dpkg/lock
dpkg --configure -a
apt-get -f install

apt-get update
apt-get -y -q upgrade


