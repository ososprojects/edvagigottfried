#! /bin/bash

exit 1

# apt-get update
apt-get install bridge-utils

# get old version; current version ist buggy
cd /tmp
wget http://old-releases.ubuntu.com/ubuntu/pool/universe/w/wpa/hostapd_1.0-3ubuntu2.1_amd64.deb
dpkg -i hostapd*.deb
apt-mark hold hostapd
cp -p /nwbox-nfs/files/etc/default/hostapd /etc/default
cp -p /nwbox-nfs/files/etc/hostapd/hostapd.conf /etc/hostapd
cp -p /nwbox-nfs/files/etc/network/interfaces /etc/network
cp -p /nwbox-nfs/files/sbin/wlan* /usr/local/sbin
chmod 777 /usr/local/sbin/*
