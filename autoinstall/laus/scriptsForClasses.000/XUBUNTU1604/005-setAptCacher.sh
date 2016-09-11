#! /bin/bash

echo "Acquire::http { Proxy \"http://apca01.agi.net:3142\"; };" > /etc/apt/apt.conf.d/02proxy
