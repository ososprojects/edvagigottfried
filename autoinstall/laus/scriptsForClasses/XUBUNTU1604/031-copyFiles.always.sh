#!/bin/sh

# copy wallpaper
cp -up /nwbox-nfs/files/wp1.jpg /usr/share/wallpapers/agi-wp.png

rsync -av /nwbox-nfs/files/nwboxuser /opt > /var/log/laus/rsync-home.log
cp -p /opt/nwboxuser/dt-main/* /opt/nwboxuser/Schreibtisch

# profile Christian
case $(hostname) in
  r404pc02 )
    cp -Rp /nwbox-nfs/files/firefox/* /opt/nwboxuser/.mozilla/firefox
  ;;
  * )
    rm -Rf /opt/nwboxuser/.mozilla/firefox/Christian
  ;;
esac

# cp /nwbox-nfs/files/etc/lightdm/lightdm.conf.d/10-xubuntu.conf /etc/lightdm/lightdm.conf.d

# copy position of desktop icons
chattr -i /opt/nwboxuser/.config/xfce4/desktop/*
rm /opt/nwboxuser/.config/xfce4/desktop/icons.screen0-*.rc
cp -p /nwbox-nfs/files/nwboxuser/.config/xfce4/desktop/icons.screen0.rc /opt/nwboxuser/.config/xfce4/desktop
chown -R nwboxuser:nwboxuser /opt/nwboxuser
chmod -R 777 /opt/nwboxuser

# copy compiz config
cp -pR /nwbox-nfs/files/nwboxuser/.config/xfce4 /opt/nwboxuser/.config
cp -pR /nwbox-nfs/files/nwboxuser/.config/compiz-1 /opt/nwboxuser/.config
cp -pR /nwbox-nfs/files/nwboxuser/.config/dconf    /opt/nwboxuser/.config
chown -R nwboxuser:nwboxuser /opt/nwboxuser
chmod -R 777 /opt/nwboxuser
chattr +i /opt/nwboxuser/.config/xfce4/desktop/icons.screen0.rc

# copy scripts
rsync -av /nwbox-nfs/files/sbin /usr/local
chmod 755 /usr/local/sbin/*

cp -upR /nwbox-nfs/files/etc/* /etc
chown -R root:root /etc/sudoers.d
chown -R root:root /etc/cron.d
chmod 755 /etc/sudoers.d
chmod 755 /etc/cron.d
chmod 644 /etc/sudoers.d/*
chmod 644 /etc/cron.d/*
chmod 644 /etc/mysql/conf.d/*

# fontconfig, wine-files for MSOffice 2010
mkdir -p /opt/mso
chmod 777 /opt/mso
chown nwboxuser:nwboxuser /opt/mso

# other files to copy

exit 1
