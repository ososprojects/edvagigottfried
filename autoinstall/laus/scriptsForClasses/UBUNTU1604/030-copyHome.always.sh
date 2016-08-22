#!/bin/bash

mkdir -p /home/nwboxuser/Schreibtisch
mkdir -p /home/nwboxuser/dt-main
mkdir -p /home/nwboxuser/dt-buero
mkdir -p /home/nwboxuser/dt-spiele

rm /home/nwboxuser/Schreibtisch/*
rm /home/nwboxuser/dt-main/*
rm /home/nwboxuser/dt-buero/*
rm /home/nwboxuser/dt-spiele/*

cp -p /nwbox-nfs/files/nwboxuser/dt-main/* /home/nwboxuser/Schreibtisch
cp -p /nwbox-nfs/files/nwboxuser/dt-main/* /home/nwboxuser/dt-main
cp -p /nwbox-nfs/files/nwboxuser/dt-buero/* /home/nwboxuser/dt-buero
cp -p /nwbox-nfs/files/nwboxuser/dt-spiele/* /home/nwboxuser/dt-spiele

chmod 777 /home/nwboxuser/dt-main/*
chmod 777 /home/nwboxuser/dt-buero/*
chmod 777 /home/nwboxuser/dt-spiele/*
chmod 777 /home/nwboxuser/Schreibtisch/*

chattr -i /home/nwboxuser/.config/xfce4/desktop/icons.screen0.rc
cp -pR /nwbox-nfs/files/nwboxuser/.config/compiz-1 /home/nwboxuser/.config
cp -pR /nwbox-nfs/files/nwboxuser/.config/dconf    /home/nwboxuser/.config
cp -pR /nwbox-nfs/files/nwboxuser/.config/xfce4    /home/nwboxuser/.config

rm /home/nwboxuser/.config/xfce4/desktop/icons.screen0-*.rc
chmod -R 777 /home/nwboxuser/.config/*
chattr +i /home/nwboxuser/.config/xfce4/desktop/icons.screen0.rc

exit 1
