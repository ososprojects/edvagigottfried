#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

add-apt-repository -y ppa:x2go/stable
apt-get update
apt-get -y install x2goserver x2goserver-xsession


