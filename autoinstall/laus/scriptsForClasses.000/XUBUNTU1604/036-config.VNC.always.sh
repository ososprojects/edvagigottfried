#!/bin/bash

case $(hostname) in
  r407pc20 )
    cp /nwbox-nfs/files/VNC/Monitoring.desktop /opt/nwboxuser/Schreibtisch
    cp /nwbox-nfs/files/VNC/Monitoring.desktop /opt/nwboxuser/dt-main
    chmod 777 /opt/nwboxuser/Schreibtisch/Monitoring.desktop
    chmod 777 /opt/nwboxuser/dt-main/Monitoring.desktop
    mkdir -p /opt/nwboxuser/.vnc
    cp /nwbox-nfs/files/VNC/vnc-hosts407.ini /opt/nwboxuser/.vnc/vnc-hosts.ini
    chown -R nwboxuser:nwboxuser /opt/nwboxuser/.vnc
    cp /nwbox-nfs/files/VNC/VNC-clients /usr/sbin
    chmod 775 /usr/sbin/VNC-clients
  ;;
  r408pc20 )
    cp /nwbox-nfs/files/VNC/Monitoring.desktop /opt/nwboxuser/Schreibtisch
    cp /nwbox-nfs/files/VNC/Monitoring.desktop /opt/nwboxuser/dt-main
    chmod 777 /opt/nwboxuser/Schreibtisch/Monitoring.desktop
    chmod 777 /opt/nwboxuser/dt-main/Monitoring.desktop
    mkdir -p /opt/nwboxuser/.vnc
    cp /nwbox-nfs/files/VNC/vnc-hosts408.ini /opt/nwboxuser/.vnc/vnc-hosts.ini
    chown -R nwboxuser:nwboxuser /opt/nwboxuser/.vnc
    cp /nwbox-nfs/files/VNC/VNC-clients /usr/sbin
    chmod 775 /usr/sbin/VNC-clients
  ;;
  *)
  ;;
esac

exit 1
