#! /bin/bash

## TODO:
##   !!!NOT TESTED TG !!!

export DEBIAN_FRONTEND=noninteractive

## Installling kicad
## instructions from http://kicad-pcb.org/download/ubuntu/
sudo add-apt-repository --yes ppa:js-reynaud/ppa-kicad
sudo apt update
sudo apt install kicad
sudo apt install kicad-locale-de


