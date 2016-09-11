#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

#apt-get -y update

# FS-utils
apt-get install -y cifs-utils
# apt-get install -y aufs-tools
apt-get install -y squashfs-tools

# java
# apt-get -y install oracle-java7-installer oracle-java7-set-default
apt-get -y install default-jre default-jre-headless
apt-get -y install default-jdk default-jdk-headless default-jdk-doc

## Secureshell - Server
## Midnight - Commander
## git - Version Control
## add exfat - filesystem
## zip

apt-get -y install openssh-server mc git gitk exfat-fuse exfat-utils p7zip p7zip-full
# configure mc
mkdir -p /root/.config/mc/mcedit
cp -Rp /nwbox-nfs/files/mc/* /root/.config/mc
chmod -R 777 /root/.config/mc 

## Firefox - Browser
apt-get -y install firefox
apt-get -y install firefox-locale-de

## Additional Chromium - Browser
apt-get -y install chromium-browser chromium-browser-l10n
# apt-get -y install pepflashplugin-installer pepperflashplugin-nonfree freshplayer
apt-get install -y browser-plugin-freshplayer-pepperflash browser-plugin-gnash

## Java - plugin for Firefox - Browser
apt-get -y install icedtea-plugin

# Zip
apt-get -y install p7zip p7zip-full

# PDF viewer, PDF editor
apt-get -y install evince okular
# apt-get -y install master-pdf-editor3

# fontviewer, fontmanager
# apt-get -y install gnome-font-viewer font-manager
apt-get -y install font-manager

## Microsoft - Corefonts (Arial, Times, ...)
## Stop script to ask for interactive EULA

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
apt-get -y install ttf-mscorefonts-installer

# MySQL-client
apt-get install -y mysql-client libmysql-java

# winbind - wird von MS Office 2010 benoetigt
apt-get -y install winbind

# zenity (dialogs!)
apt-get install -y zenity

# pcmanfm (file manager)
apt-get install -y pcmanfm

# simple/enhanced scanner program
apt-get -y install sane xsane

# editors
apt-get -y install mousepad jedit emacs24 bless bluefish gedit

# DosBox Emulator
apt-get -y install dosbox

# packet manager
apt-get -y install synaptic

# cd/dvd burner
apt-get -y install brasero

## Betrachter fuer entfernte Bildschirme
apt-get -y install vinagre

# ssh client
apt-get -y install remmina

apt-get -y install gparted

# menu editor
apt-get -y install menulibre

# vnc
apt-get -y install x11vnc xtightvncviewer ssvnc

# ftp client
apt-get -y install filezilla

# password generator
apt-get -y install pwgen

# DTP program
apt-get -y install scribus

# cdeject
apt-get -y install cdtool
