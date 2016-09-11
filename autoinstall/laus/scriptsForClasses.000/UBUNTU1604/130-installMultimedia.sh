#! /bin/bash

#apt-get -y update

## some Multimedia - Codecs
# apt-get -y install libmp3lame0 libtunepim5-mp3 libk3b6-extracodecs libavodec-unstripped-52 libxine1-ffmpeg
apt-get -y install libmp3lame0 libk3b6 libk3b6-extracodecs
apt-get install -y libavcodec-extra libavcodec-ffmpeg-extra56
apt-get install -y libxine2 libxine2-ffmpeg

## Stuff to play DVDs
apt-get -y install libdvdread4
# run script to make libdvdread4 working
/usr/share/doc/libdvdread4/install-css.sh

## Media - Players
apt-get -y install audacity smplayer smtube
apt-get -y install vlc browser-plugin-vlc

## cheese (for camera)
apt-get -y install cheese

## CD ripper
apt-get install -y ripperx

