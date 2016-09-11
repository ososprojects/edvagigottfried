#! /bin/bash

echo "Dpkg::Options { \"--force-confdef\"; \"--force-confold\"; };" > /etc/apt/apt.conf.d/03force-conf
