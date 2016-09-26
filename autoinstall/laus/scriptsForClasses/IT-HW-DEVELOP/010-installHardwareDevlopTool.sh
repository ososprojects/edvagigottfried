#! /bin/bash

## TODO:
##  TESTED on r407pc16 TG !!!

export DEBIAN_FRONTEND=noninteractive

## Installling kicad
## instructions from http://kicad-pcb.org/download/ubuntu/
sudo add-apt-repository --yes ppa:js-reynaud/ppa-kicad
sudo apt update
sudo apt -y install kicad
sudo apt -y install kicad-locale-de


