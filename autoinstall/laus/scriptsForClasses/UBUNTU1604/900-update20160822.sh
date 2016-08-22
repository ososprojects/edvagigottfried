#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

rm /var/lib/dpkg/updates/*
rm /var/lib/dpkg/lock
dpkg --configure -a
apt-get -f install

apt-get update
apt-get -y upgrade

