#!/bin/bash

case $(hostname) in
  r102pc01 | r110* | r208pc01 | r210pc01 | r310pc01)
    cp -p /nwbox-nfs/files/dt-main.lehrer/* /opt/nwboxuser/dt-main
    cp -p /nwbox-nfs/files/dt-main.lehrer/* /opt/nwboxuser/Schreibtisch
    chmod 777 /opt/nwboxuser/dt-main/*
    chmod 777 /opt/nwboxuser/Schreibtisch/*
  ;;
  r009pc03 )
    cp -p /nwbox-nfs/files/dt-main.sbib/* /opt/nwboxuser/dt-main
    cp -p /nwbox-nfs/files/dt-main.sbib/* /opt/nwboxuser/Schreibtisch
    chmod 777 /opt/nwboxuser/dt-main/*
    chmod 777 /opt/nwboxuser/Schreibtisch/*
  ;;
  * )
  ;;
esac

exit 1
