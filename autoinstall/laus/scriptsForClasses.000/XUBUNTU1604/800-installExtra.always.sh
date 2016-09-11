#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

# MS Office 2010 needs winbind
apt-get -y install winbind

# for smb printers
apt-get -y install smbclient

# cdeject
apt-get -y install cdtool

apt-get -y install wmctrl

apt-get -y -q install virtualbox-ext-pack
apt-mark hold virtualbox-ext-pack

exit 1

