#! /bin/bash

## write repository-URL to file
FILE="/etc/apt/sources.list.d/geogebra.list"

echo "deb http://www.geogebra.net/linux/ stable main" > $FILE
echo "" >> $FILE

## get GPG key of the repository
wget --quiet  http://www.geogebra.net/linux/office@geogebra.org.gpg.key -O - | sudo apt-key add -

## udate local repository and install
apt-get update
apt-get install geogebra5
