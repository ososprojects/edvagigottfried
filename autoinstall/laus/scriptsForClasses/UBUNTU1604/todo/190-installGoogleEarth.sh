#!/bin/bash

# Extrakt File 
# with
# FILENAME
# from
# SOURCE_PATH
# to 
# DESTINATION_PATH

# Source Laus-Settings
. /etc/default/laus-setup

SOURCE_PATH=$MOUNT_PATH_ON_CLIENT/xBigFiles

apt-get -y update

apt-get -y install lsb-core 

if [ $(uname -m) == "x86_64" ];
then
	apt-get -y install libc6:i386 libfontconfig1:i386 libglib2.0-0:i386 libglu1-mesa:i386 libsm6:i386 libx11-6:i386 libxext6:i386 libxrender1:i386 
	pkg=$(dpkg-query -l libgl1-mesa-glx | grep -m1 ^ii[[:space:]]* | grep -o libgl1-mesa-glx[[:graph:]]* | sed -r s/:\(i386\|amd64\)/""/g)
	apt-get -y install $pkg:i386
fi

dpkg -i $SOURCE_PATH/google-earth.deb

