#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

apt-get install -q -y \
  xubuntu-desktop xubuntu-default-settings \
  xubuntu-artwork xubuntu-community-wallpapers xfce4-goodies \
  xubuntu-restricted-addons xubuntu-restricted-extras \
  wmctrl

