#! /bin/bash

date > /var/log/laus/update_end.log
sleep 20
systemctl reboot
