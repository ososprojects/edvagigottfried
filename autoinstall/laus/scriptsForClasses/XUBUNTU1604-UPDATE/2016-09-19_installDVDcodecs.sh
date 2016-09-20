#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

## Stuff to play DVDs
apt-get -y install libdvd-pkg
dpkg-reconfigure libdvd-pkg
