#! /bin/bash

apt-get -y install python-software-properties software-properties-common

add-apt-repository -y ppa:ubuntu-wine/ppa
# add-apt-repository -y ppa:videolan/stable-daily
# add-apt-repository -y ppa:chromium-daily/stable
# add-apt-repository -y ppa:skunk/pepper-flash
add-apt-repository -y ppa:rvm/smplayer
add-apt-repository -y ppa:audacity-team/daily
# add-apt-repository -y ppa:libreoffice/libreoffice-5-1
add-apt-repository -y ppa:mscore-ubuntu/mscore-stable

apt-get -y update


