#!/bin/bash

date > /var/log/time-copyWin7.log

mkdir -p /opt/VMs
chmod 777 /opt/VMs

# Win7 mit MS-Office2013 an den Lehrergeräten
# und in der Aula (r086pc01)
# WinXP-Littera an SBIB03
case $(hostname) in
  r102pc01 | r110* | r208pc01 | r210pc01 | r310pc01 | r408pc20 | r408pc01 | r086pc01 )
    rsync --delete -av /nwbox-nfs/VMs/Win7 /opt/VMs > /var/log/vms.log
    chmod -R 777 /opt/VMs
    chown -R nwboxuser:nwboxuser /opt/VMs
  ;;
  *)
  ;;
esac

# WinXP an SBIB03
case $(hostname) in
  r009pc03 )
    rsync --delete -av /nwbox-nfs/VMs/WinXP-Littera /opt/VMs > /var/log/vms-XP.log
    chmod -R 777 /opt/VMs
    chown -R nwboxuser:nwboxuser /opt/VMs
  ;;
  *)
  ;;
esac

date >> /var/log/time-copyWin7.log

exit 1

case $(hostname) in
#  k*01 | l* | biu01 | biu02 | ch01 | physik01 | k3304)
  r*01 | r010* | biu01 | biu02 | ch01 | physik01 | k3304)
   r*pc01 | r408pc20 | r110* | r210* | r310* )
    cp -R /nwbox/fueralle/TINspire/VirtualBox /home/nwboxuser/.config > /var/log/copyTI01.log
    chmod -R 777 /home/nwboxuser/.config/VirtualBox
    chown -R nwboxuser:nwboxuser /home/nwboxuser/.config/VirtualBox
    mkdir /opt/VMs/WinXP-TI
    cp -R -up /nwbox/fueralle/TINspire/WinXP-TI/VMs/WinXP-TI/* /opt/VMs/WinXP-TI
    cp -p /nwbox/fueralle/TINspire/WinXP-TI/VMs/WinXP-TI/*.vbox /opt/VMs/WinXP-TI
    cp -p /nwbox/fueralle/TINspire/WinXP-TI/VMs/WinXP-TI/*.vbox-prev /opt/VMs/WinXP-TI
    cp /nwbox/fueralle/TINspire/WinXP-TI/VMs/WinXP-TI/Snapshots/* /opt/VMs/WinXP-TI/Snapshots
    chmod -R 777 /opt/VMs
    chmod 755 /opt/VMs/WinXP-TI/*.vdi
    mkdir /opt/Programme
    cp -R -up /nwbox/fueralle/TINspire/WinXP-TI/Programme/* /opt/Programme > /var/log/copyTI02
    chmod -R 755 /opt/Programme
    cp -p /nwbox/public/data/TI-Nspire.desktop /Menu/Mathematik
    chmod 755 /Menu/Mathematik/TI-Nspire.desktop
    mkdir /opt/Start
    cp /nwbox/public/data/Start/* /opt/Start
    chmod -R 777 /opt/Start
    cp /nwbox/public/data/winxp /usr/local/sbin
    chmod 755 /usr/local/sbin/winxp
  ;;
  *)
  ;;
esac

# Win7 in VirtualBox an den Lehrergeräten

case $(hostname) in
#  l0* | aula )
  r408pc20 | r102* | r110* | r208* | r210* | r310* )
    mkdir -p /opt/VMs
    mkdir -p /opt/VMs/Win7
    rm /opt/VMs/Win7/*.vbox
    rm /opt/VMs/Win7/*.vbox-prev
    rm -rf /opt/VMs/Win7/Snapshots
    mkdir /opt/VMs/Win7/Snapshots
    chattr -i /opt/VMs/Win7/Win7.vdi
    cp -Rp /nwbox/fueralle/Win7-config/VirtualBox /home/nwboxuser/.config
    cp -up /nwbox/fueralle/Win7/*.vdi /opt/VMs/Win7
    cp -p /nwbox/fueralle/Win7/Snapshots/* /opt/VMs/Win7/Snapshots
    cp -p /nwbox/fueralle/Win7/*.vbox-prev /opt/VMs/Win7
    cp -p /nwbox/fueralle/Win7/*.vbox /opt/VMs/Win7
#    cp -p /nwbox/fueralle/Win7-config/Win7.desktop /home/nwboxuser/Schreibtisch
    chmod -R 777 /home/nwboxuser/.config/VirtualBox
    chown -R nwboxuser:nwboxuser /home/nwboxuser/.config/VirtualBox
    chmod -R 777 /opt/VMs/Win7
#    chmod 755 /opt/VMs/Win7/*.vdi
    chattr +i /opt/VMs/Win7/Win7.vdi
#    apt-get install -y wmctrl
  ;;
  *)
  ;;
esac

chmod 755 /home/nwboxuser/Schreibtisch/*.desktop
chown nwboxuser:nwboxuser /home/nwboxuser/Schreibtisch/*.desktop
chattr -R +i /Menu/*

# rm "/Orte/2. Daten (lokal)"
# ln -s /home/nwboxuser "/Orte/2. Daten (lokal)"

exit 1
