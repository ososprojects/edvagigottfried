#! /bin/sh

mkdir -p /media/nwboxuser
chown -R nwboxuser:nwboxuser /media/nwboxuser

mkdir -p /Orte
rm /Orte/*
chown -R nwboxuser:nwboxuser /Orte

ln -s /nwbox/homes-m   "/Orte/1. Daten (am Server)"
ln -s /nwbox/austausch "/Orte/2. Austauschverzeichnis"
ln -s /media/nwboxuser "/Orte/3. USB-Sticks"
ln -s /nwbox/videos    "/Orte/4. Videos (am Server)"
ln -s /nwbox/bilder    "/Orte/5. Bilder (am Server)"

exit 1

