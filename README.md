# edvagi

#Starten der Geräte am AGI
##1  Konzept
###1.1  Laus-Skripte
Durch diese Skripte werden Installationen ausgeführt und Grundeinstellungen angepasst.
####Am Client
Auf jedem Gerät ist in /usr/local/sbin die Datei laus-client.sh, die bei der Installation dorthin kopiert wurde. Sie sorgt dafür, dass beim Start die Skripte am Server ausgeführt werden.
####Am Server
Dort gibt es die Datei hostsToClasses im Verzeichnis /opt/autoinstall/laus. In dieser steht, aus welchen Verzeichnissen Skripte ausgeführt werden sollen.
	r407: UBUNTU1604 XUBUNTU1604 SAMBA.XFCE
bedeutet z.B., dass an Geräten, deren Hostname mit r407 beginnt, die Skripte aus
	/opt/autoinstall/laus/scriptsForClasses/UBUNTU1604
	/opt/autoinstall/laus/scriptsForClasses/XUBUNTU1604
	/opt/autoinstall/laus/scriptsForClasses/SAMBA.XFCE
(in dieser Reihenfolge!) ausgeführt werden sollen.
Diese Angabe ist kumulativ:
	r407: XUBUNTU1604 SAMBA.XFCE
	r407pc20: LEHRERGERAETE
bedeutet, dass auf r407pc20 XUBUNTU1604, SAMBA.XFCE und LEHRERGERAETE genommen wird.
###Am Client:
Jedes Skript, das fehlerfrei ausgeführt wurde, wird in /var/log/laus eingetragen und daher beim nächsten Start übersprungen.
Soll ein Skript bei jedem Start ausgeführt werden, hilft ein Trick: In der letzten Zeile steht „exit 1“, womit das Skript mit einem „Fehler“ beendet und daher nicht in /var/log/laus eingetragen wird. Um die Übersichtlichkeit zu erhöhen, sollten solche Skripte mit *.always.sh benannt werden.
###1.2  Konfiguration
Die Konfiguration von Desktop und Programmen steht unter Linux im Home-Verzeichnis, bei uns also in /home/nwboxuser. Der Inhalt dieses Verzeichnisses wird am Server im Verzeichnis
	/opt/files/nwboxuser
gesichert. Am Client ist eine Kopie davon in /opt/nwboxuser, die bei jedem Start mit dem Server abgeglichen und dann als Homeverzeichnis eingebunden wird.
Dazu dient in 990-mountOverlayFS.always.sh das Kommando
	mount -t aufs -o dirs=/nwboxuser-rw:/opt/nwboxuser none /home/nwboxuser
/opt/nwboxuser ist damit readonly, alle Änderungen werden in /nwboxuser-rw gespeichert.
Der zusätzliche Parameter udba=eval („user direct branch access“) dient dazu, dass eventuelle nachträgliche Änderungen in /opt/nwboxuser sich auch auf das Home-Verzeichnis auswirken.
Linux-Geräte führen Startvorgänge nach Möglichkeit parallel aus, um den Bootvorgang zu beschleunigen. Es kann daher vorkommen, dass die Aktualisierung von /opt/nwboxuser noch nicht abgeschlossen ist, wenn der Desktop aktiviert wird. Daher werden ganz am Beginn - also noch bevor /home/nwboxuser mit AUFS gemountet wird - mit dem Skript  030-copyHome.always.sh einige Verzeichnisse und Dateien nach /home/nwboxuser kopiert, außerdem die Desktop-Icons des Haupt-Desktops. Anschließend werden - abhängig vom Gerätenamen - mit 035-configLehrer.sh die Desktop-Icons der Lehrergeräte hinzugefügt.
Anmerkung: In /etc/fstab werden bereits beim Start mit 
	/opt/autoinstall	/export/autoinstall	0	0
	/opt/files	/export/files	0	0
diese beiden Verzeichnisse nach /export „gespiegelt“ und von dort per nfs exportiert, sodass sie am Client in /nwbox-nfs sichtbar sind.

##2  Aufsetzen eines neuen Geräts
MAC-Adresse in DHCP eintragen
Beim Starten Ubuntu1404 wählen
Passwort 123 eingeben
„2 Partitionen, 2 formatieren“ mit Enter bestätigen
##3  Starten eines bereits installierten Gerätes
In der NetworkBox gibt es mehrere Verzeichnisse. In diesen werden die Skripte, deren Dateinamen auf .always.sh enden, bei jedem Start ausgeführt:
UBUNTU1604
001-mountNFS.always.sh
030-copyHome.always.sh
035-configLehrer.sh
XUBUNTU1604
800-installExtra.always.sh
990-mountOverlayFS.always.sh
SAMBA.XFCE
001-mountNFS,always.sh
020-nwbox-mount.always.sh
030-installOrte.always.sh
040-installPrinters.always.sh
LEHRERGERAETE
010-nwbox-L-Orte.always.sh
WIN7VB
010-copyWin-VB.always.sh
AGI
Für eventuelle schulspezifische Skripte
##4  Beschreibung der Startskripte
Durch Veränderung dieser Skripte ist es auf sehr einfache Weise möglich, die Konfiguration kurzfristig anzupassen, etwa um einen defekten Drucker auszublenden.
###4.1  001-mountNFS.always.sh
Die Freigabe des NFS-Servers wird auf /nwbox-nfs gemountet, um von dort Dateien zu kopieren.
###.2  012-copyHome.always.sh
Von /nwbox-nfs/files/nwboxuser werden einige Verzeichnisse und Konfigurationsdateien  nach /home/nwboxuser kopiert, außerdem die Icons des Haupt-Desktops.
####Spezielle Dateien und Verzeichnisse:
icons.screen0.rc
In ~/.config/xfce4/desktop wird für jede Bildschirmauflösung eine Datei icons.screen0-(Auflösung).rc angelegt, in der die Position der Desktop-Icons steht. Fehlt sie, wird icons.screen0.rc als Vorlage genommen.
Damit ist es möglich, in dieser Datei die Position der Desktop-Icons festzulegen. Für eine Änderung muss nur die Datei am Server geändert werden!
~/.config/compiz-1
Hier stehen Compiz-Einstellungen, z.B. welche Features aktiviert sind oder wie die Bilschirmlupe aktiviert wird.
~/.config/dconf
Hier stehen in der Datei „user“ die Einstellungen, die mit dem dconf-Editor vorgenommen wurden, z.B. das Thema oder die Anordnung der Buttons im Fensterrahmen.
~/.config/xfce4
Hier ist im Unterverzeichnis desktop die bereits erwähnte Datei icons.screen0.rc,
im Unterverzeichnis xfconf in der Datei xfce4-session.xml, welcher Window-Manager verwendet werden soll (xfwm4 oder compiz).
###4.3  013-copyHomeExtra.always.sh
Hier werden die zusätzlichen Icons für die Lehrer-PCs kopiert.
###4.4  031-copyFiles.always.sh
Neue oder veränderte Dateien werden nach /opt/nwboxuser kopiert.
Außerdem gibt dieses Skript die Möglichkeit, einzelne Dateien gegen aktualisierte Versionen auszutauschen.
Dazu werden zwei Kommandos verwendet:
	cp -upR ...
	u bedeutet, dass nur kopier wird, wenn die Datei neuer ist als die Zieldatei.
	R bedeutet rekursiv.
	p bedeutet, dass Zeit und Berechtigungen der Datei(en) erhalten bleiben sollen.
	rsync -av --delete ...
	a ist ein „Sammelparameter“: Zeit, Eigentümer, Gruppe und Rechte bleiben erhalten.
	v bedeutet „verbose“, um Output für /var/log/laus/rsync-home.log zu generieren.
	-- delete bedeutet, dass Dateien, die in der Quelle nicht vorhanden sind, im Ziel gelöscht werden.
	(VORSICHT!!!)
###4.5  800-installExtra..always.sh
Nachträgliche Installation oder Aktualisierung von Paketen.
###4.6  900-configLehrer.always.sh
###4.7  990-mountAUFS.always.sh
/opt/nwboxuser wird als Homeverzeichnis auf /home/nwboxuser gemounted. Als Schreibschicht für AUFS dient /nwboxuser-rw, das vorher geleert wird.
###4.8  020-mount-nwbox.always.sh
In diesem Skript werden die Samba-Freigaben gemounted, z.B. /smb01/austausch auf /nwbox/austausch.
###4.9  030-installOrte.always.sh
Die Speicherorte werden als Links eingebunden.
###4.10  040-installPrinters.always.sh
Zuerst werden alle Drucker gelöscht. Dann werden abhängig vom Hostnamen die passenden Drucker eingebunden.
##5  Installation neuer Programme
Dazu wird einfach ein neues Skript angelegt.
Es ist empfehlenswert, das Skript zuerst an einer Station zu testen! Dazu wird es über
	/nwbox-nfs/autoinstall/laus/scriptsForClasses/...
aufgerufen.
Es ist empfehlenswert, an einem Gerät sofort nach der Installation das Programm - falls nötig - zu konfigurieren und dann die Einstellungen zu sichern wie im nächsten Abschnitt beschrieben.
##6  Sicherung der Einstellungen
Im GUI abmelden
Auf einer Textkonsole „sichern“ aufrufen.
Damit wird Das Serververzeichnis mit nwboxuser auf /mnt gemounted.
Anschließend werden mit rsysnc die Änderungen am Server gespeichert.
Unter Umständen sollte vorher am Server das Verzeichnis nwboxuser gesichert werden, z.B. mit
	mkdir /export/files/2016-07-19
	rsync -av /export/files/nwboxuser /export/files/2016-07-19
Wurde in PlayOnLinux nichts verändert, genügt
	mkdir /export/files/2016-07-19
	rsync -av --exclude '.PlayOnLinux' /export/files/nwboxuser /export/files/2016-07-19
Für diese Zwecke habe ich folgende Skripte angelegt:
###6.1  am Client
sichern
Sicherung auf den Server ohne PlayOnLinux
Die Änderungen werden in /var/log/laus/sichern.log gespeichert.
sichern_POL
Sicherung auf den Server mit PlayOnLinux
Die Änderungen werden in /var/log/laus/sichern_POL.log gespeichert.
sichern-n und sichern_POL-n
Der zusätzliche Parameter -n bei rsync bewirkt, dass nichts kopiert wird. Es wird nur angezeigt, was kopiert würde.
Die Ausgabe kann auch mit > (Dateiname) in eine Datei umgeleitet werden.
###6.2  am Server
Hier gibt es in /root die Dateien sichern-server.sh und sichern-server_POL.sh. Mit diesen wird praktisch der gesamte Server im Verzeichnis /DATEN/sicherung/(Datum und Zeit) gesichert:
/export/autoinstall (die Skripte) und /export/files in export.sq
/var/lib/tftpboot in tftpboot.sq
/var/lib/mysql in mysql.sq
Dazu Server-Konfigurationsdateien aus /etc (v.a. DHCP, DNS, Samba, Netzwerkeinstellungen)
Die Dateien *.sq sind Squashfs-Dateien. Dabei wird mit mksquashfs ein ganzer Verzeichnisbaum in eine Datei gepackt. Mit z.B.
	mount -o loop export.sq /mnt
wird dieser dann wieder in /mnt eingebunden, dann können mit mc alle oder einzelne Dateien wieder irgendwohin kopiert werden.
