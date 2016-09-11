#!/bin/sh

# copy scripts
rsync -av /nwbox-nfs/files/sbin /usr/local
chmod 755 /usr/local/sbin/*

# copy client configuration files and set correct attributes
cp -upR /nwbox-nfs/files/etc/* /etc
chown -R root:root /etc/sudoers.d
chown -R root:root /etc/cron.d
chmod 755 /etc/sudoers.d
chmod 755 /etc/cron.d
chmod 644 /etc/sudoers.d/*
chmod 644 /etc/cron.d/*
chmod 644 /etc/mysql/conf.d/*

cp -Rp /nwbox-nfs/files/var/* /var

# fontconfig, wine-files for MSOffice 2010
mkdir -p /opt/mso
chmod 777 /opt/mso
chown nwboxuser:nwboxuser /opt/mso

# other files to copy

# copy wallpaper
cp -up /nwbox-nfs/files/wp1.jpg /usr/share/wallpapers

# copy home
chattr -i /opt/nwboxuser/.config/xfce4/desktop/*
rsync -av --delete /nwbox-nfs/files/nwboxuser /opt > /var/log/laus/rsync-home.log
rm /opt/nwboxuser/.config/xfce4/desktop/icons.screen0-*
cp -p /opt/nwboxuser/dt-main/* /opt/nwboxuser/Schreibtisch

# firefox profile Christian
case $(hostname) in
  r404pc02 )
    cp -Rp /nwbox-nfs/files/firefox/* /opt/nwboxuser/.mozilla/firefox
    chown -R nwboxuser:nwboxuser /opt/nwboxuser/.mozilla/firefox/*
    chmod -R 777 /opt/nwboxuser/.mozilla/firefox/*
  ;;
  * )
    rm -Rf /opt/nwboxuser/.mozilla/firefox/Christian
  ;;
esac

chown -R nwboxuser:nwboxuser /opt/nwboxuser
chmod -R 777 /opt/nwboxuser
chattr +i /opt/nwboxuser/.config/xfce4/desktop/icons.screen0.rc

exit 1