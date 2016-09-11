#! /bin/bash

# vorerst versuchsweise nur für 4 Geräte

case $(hostname) in
  r407pc05 |  r407pc06 |  r407pc07 |  r407pc08 ) 
    export DEBIAN_FRONTEND=noninteractive

    rm /var/lib/dpkg/updates/*
    rm /var/lib/dpkg/lock
    dpkg --configure -a
    apt-get -f install

    apt-get update
    apt-get -y -q upgrade
  ;;
  * )
  ;;
esac


