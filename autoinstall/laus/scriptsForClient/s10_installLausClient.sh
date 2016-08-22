#!/bin/bash

# install nfs - Client
sudo apt-get -y update

sudo apt-get -y install nfs-common

# copy LAUS - Setupfile to /etc/default
echo "copy LAUS - Setup - File to /etc/default"
sudo cp -v ./laus-setup  /etc/default/

echo "copy LAUS - Start - Script to /etc/init"
sudo cp -v ./laus-client.conf  /etc/init/
sudo chmod 755 /etc/init/laus-client.conf

