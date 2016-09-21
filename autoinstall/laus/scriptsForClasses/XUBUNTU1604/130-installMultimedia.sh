#! /bin/bash

export DEBIAN_FRONTEND=noninteractive

#apt-get -y update

## some Multimedia - Codecs
# apt-get -y install libmp3lame0 libtunepim5-mp3 libk3b6-extracodecs libavodec-unstripped-52 libxine1-ffmpeg
apt-get -y install libmp3lame0 libk3b6 libk3b6-extracodecs
apt-get install -y libavcodec-extra libavcodec-ffmpeg-extra56
apt-get install -y libxine2 libxine2-ffmpeg

## Stuff to play DVDs
apt-get -y install libdvdread4
apt-get -y install libdvd-pkg   # eingefügt 2016-09-19
dpkg-reconfigure libdvd-pkg     # eingefügt 2016-09-19

## Media - Players
apt-get -y install audacity smplayer smtube
apt-get -y install vlc browser-plugin-vlc

## cheese (for camera)
apt-get -y install cheese

## CD ripper
apt-get install -y ripperx

