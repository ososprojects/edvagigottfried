#!/bin/bash

exit 1

case $(hostname) in
  r102pc01 | r110* | r208pc01 | r210pc01 | r310pc01)
    cp -p /nwbox-nfs/files/dt-main.lehrer/* /home/nwboxuser/dt-main
    cp -p /nwbox-nfs/files/dt-main.lehrer/* /home/nwboxuser/Schreibtisch
    chmod 777 /home/nwboxuser/dt-main/*
    chmod 777 /home/nwboxuser/Schreibtisch/*

    cp -p /nwbox-nfs/files/dt-main.lehrer/* /opt/nwboxuser/dt-main
    cp -p /nwbox-nfs/files/dt-main.lehrer/* /opt/nwboxuser/Schreibtisch
    chmod 777 /opt/nwboxuser/dt-main/*
    chmod 777 /opt/nwboxuser/Schreibtisch/*
###    xfdesktop --reload
  ;;
  r009pc03 )
    cp -p /nwbox-nfs/files/dt-main.sbib/* /home/nwboxuser/dt-main
    cp -p /nwbox-nfs/files/dt-main.sbib/* /home/nwboxuser/Schreibtisch
    chmod 777 /home/nwboxuser/dt-main/*
    chmod 777 /home/nwboxuser/Schreibtisch/*

    cp -p /nwbox-nfs/files/dt-main.sbib/* /opt/nwboxuser/dt-main
    cp -p /nwbox-nfs/files/dt-main.sbib/* /opt/nwboxuser/Schreibtisch
    chmod 777 /opt/nwboxuser/dt-main/*
    chmod 777 /opt/nwboxuser/Schreibtisch/*
  ;;
  * )
  ;;
esac

# date > /var/log/time-configLehrer.log

exit 1
