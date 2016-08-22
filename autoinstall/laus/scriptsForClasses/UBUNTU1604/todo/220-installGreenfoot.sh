#! /bin/bash

. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

#apt-get -y install openjdk-7-jdk

dpkg -i $SOURCE_PATH/greenfoot.deb
