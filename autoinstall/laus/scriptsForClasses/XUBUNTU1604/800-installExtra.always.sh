#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

# MS Office 2010 needs winbind
apt-get -y install winbind

# for smb printers
apt-get -y install smbclient

exit 1

