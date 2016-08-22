#! /bin/bash

. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

#apt-get -y update

## Eclipse
apt-get -y install eclipse

## install Plugins

## install Derby - Plugin
cp -Rp $SOURCE_PATH/eclipse-dropins/derby	/usr/share/eclipse/dropins

## install Lejos - Plugin
cp -Rp $SOURCE_PATH/eclipse-dropins/lejos	/usr/share/eclipse/dropins

## install Python - Plugin
cp -Rp $SOURCE_PATH/eclipse-dropins/python	/usr/share/eclipse/dropins
