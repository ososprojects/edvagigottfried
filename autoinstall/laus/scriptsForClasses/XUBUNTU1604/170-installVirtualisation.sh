#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

## Wine
## Virtualbox
apt-get -y --allow-unauthenticated install playonlinux wine
apt-get -y install virtualbox
apt-mark hold virtualbox
apt-get -y -q install virtualbox-ext-pack
apt-mark hold virtualbox-ext-pack
