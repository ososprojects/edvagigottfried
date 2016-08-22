#! /bin/bash

if  ! [ -e /etc/apt/sources.list.d/owncloud.list ];
then
#	wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/xUbuntu_14.04/Release.key -O- | apt-key add - 
	wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key -O- | apt-key add - 

#	echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/xUbuntu_14.04/ /" >> /etc/apt/sources.list.d/owncloud.list	
	echo "deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_16.04/ /" >> /etc/apt/sources.list.d/owncloud.list	
fi
	
apt-get -y update
apt-get -y install owncloud-client


