#Starten der Geräte am AGI
##1  Konzept
###1.1  Laus-Skripte
Durch diese Skripte werden Installationen ausgeführt und Grundeinstellungen angepasst.
#### Am Client
Auf jedem Gerät ist in /usr/local/sbin die Datei laus-client.sh, die bei der Installation dorthin kopiert wurde. Sie sorgt dafür, dass beim Start die Skripte am Server ausgeführt werden.
#### Am Server
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
#### Am Client:
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
###4.1  in UBUNTU1604
#### 000-rmLog.always.sh
Wenn „exit 1“ am Anfang entfernt wird, werden alle Skripte in /var/log/laus gelöscht, sodass alle nochmals ausgeführt werden.
#### 001-mountNFS.always.sh
Die Freigabe des NFS-Servers wird auf /nwbox-nfs gemountet, um von dort Dateien zu kopieren.
#### 011-unlockApt.always.sh
Reparatur von defekten Paketabhängigkeiten, etwa wenn der Installationsprozess durch Abschalten des Geräts abgebrochen wurde
#### 030-copyHome.always.sh
Alle Desktop-Icons und ihre Position werden gelöscht und vom Server neu nach /home/nwboxuser kopiert, außerdem die Konfiguration von Compiz. Dabei handelt es sich um folgende Dateien und Verzeichnisse:
##### icons.screen0.rc
In ~/.config/xfce4/desktop wird für jede Bildschirmauflösung eine Datei icons.screen0-(Auflösung).rc angelegt, in der die Position der Desktop-Icons steht. Fehlt sie bzw. wird sie gelöscht, wird icons.screen0.rc als Vorlage genommen, um sie neu anzulegen.
Damit ist es möglich, in dieser Datei die Position der Desktop-Icons festzulegen. Für eine Änderung muss nur die Datei am Server geändert werden!
##### ~/.config/compiz-1
Hier stehen Compiz-Einstellungen, z.B. welche Features aktiviert sind oder wie die Bilschirmlupe aktiviert wird.
##### ~/.config/dconf
Hier stehen in der Datei „user“ die Einstellungen, die mit dem dconf-Editor vorgenommen wurden, z.B. das Thema oder die Anordnung der Buttons (rechts oben; minimize, maximize, close) im Fensterrahmen.
##### ~/.config/xfce4
Hier ist im Unterverzeichnis desktop die bereits erwähnte Datei icons.screen0.rc,
im Unterverzeichnis xfconf steht in der Datei xfce4-session.xml, welcher Window-Manager verwendet werden soll (xfwm4 oder compiz).
#### 035-configLehrer.always.sh
Hier werden zusätzliche Desktop-Icons in Unterverzeichnisse von /home/nwboxuser und von /opt/nwboxuser kopiert.
###4.2  in XUBUNTU1604
#### 031-copyFiles.always.sh
Neue oder veränderte Dateien werden nach /opt/nwboxuser kopiert.
Außerdem gibt dieses Skript die Möglichkeit, einzelne Dateien gegen aktualisierte Versionen auszutauschen.
Dazu werden zwei Kommandos verwendet:
	cp -upR ...
	u bedeutet, dass nur kopiert wird, wenn die Datei neuer ist als die Zieldatei.
	R bedeutet rekursiv.
	p bedeutet, dass Zeit und Berechtigungen der Datei(en) erhalten bleiben sollen.
	rsync -av --delete ...
	a ist ein „Sammelparameter“: Zeit, Eigentümer, Gruppe und Rechte bleiben erhalten.
	v bedeutet „verbose“, um Output für /var/log/laus/rsync-home.log zu generieren.
	-- delete bedeutet, dass Dateien, die in der Quelle nicht vorhanden sind, im Ziel gelöscht werden.
	(VORSICHT!!!)
#### 800-installExtra..always.sh
Nachträgliche Installation oder Aktualisierung von Paketen.
#### 900-mountOverlayFS.always.sh
/opt/nwboxuser wird als Homeverzeichnis auf /home/nwboxuser gemounted. Als Schreibschicht für AUFS dient /nwboxuser-rw, das vorher geleert wird.
###4.3  in SAMBA.XFCE
#### 020-mount-nwbox.always.sh
In diesem Skript werden die Samba-Freigaben gemounted, z.B. /smb01/austausch auf /nwbox/austausch.
#### 030-installOrte.always.sh
Die Speicherorte werden als Links in /Orte eingebunden.
#### 040-installPrinters.always.sh
Es wird (max. 1 Minute) gewartet, bis CUPS bereit ist.
Dann werden zuerst alle Drucker gelöscht.
Dann werden abhängig vom Hostnamen die passenden Drucker eingebunden.
###4.4  in LEHRERGERAETE
#### 010-nwbox-L-Orte.always.sh
An den Lehrergeräten werden zusätzliche Samba-Freigaben gemountet und als Links in /Orte eingebunden.
###4.5  in WIN7VB
##### 010-copyWin-VB.always
Dateien von VirtualBox werden nach /opt/VMs kopiert. Da dafür rsync --delete verwendet wird, werden alle Änderungen verworfen.
Anmerkung:
Wurde eine virtuelle Maschine geändert, können die Änderungen dauerhaft am Server gespeichert werden, und zwar mit
	rsync -av /opt/VMs/(virtuelle Maschine)   nfs01:/export/files/VMs
##5  Updates
in UBUNTU1604 wird ein Skript mit dem Namen 900-update(Datum).sh angelegt, z.B. 900‑update‑20160823. In diesem werden zuerst die Paketabhängigkeiten - falls nötig - korrigiert und dann das Update durchgeführt.
Folgende Vorgangsweise ist empfehlenswert:
Altes Skript umbenennen, indem das Datum im Dateinamen aktualisiert wird.
Damit hat das Skript einen neuen Namen, der noch nicht in /var/log/laus steht, und wird daher an jeder Station einmal ausgeführt.
Skript an einer Station testen, indem es in der Textkonsole über /nwbox-nfs/autoinstall/... aufgerufen wird.
##6  Installation neuer Programme
Dazu wird einfach ein neues Skript angelegt.
Es ist empfehlenswert, das Skript zuerst an einer Station zu testen! Dazu wird es über
	/nwbox-nfs/autoinstall/laus/scriptsForClasses/...
aufgerufen.
Es ist empfehlenswert, an einem Gerät sofort nach der Installation das Programm - falls nötig - zu konfigurieren und dann die Einstellungen zu sichern wie im nächsten Abschnitt beschrieben.
##7  Sicherung der Einstellungen
Im GUI abmelden
Auf einer Textkonsole „sichern“ bzw. „sichern_POL“ aufrufen.
Damit werden mit rsysnc die Änderungen im Homeverzeichnis über ssh am Server gespeichert, und zwar in /export/files/nwboxuser/...
Vorher sollte am Server das Verzeichnis nwboxuser (also die bisherige Konfiguration) gesichert werden, indem man dort ~/sichern‑server.sh bzw. ~/sichern‑server_POL.sh aufruft.
Für diese Zwecke habe ich folgende Skripte angelegt:
###7.1  am Client
sichern
Sicherung auf den Server ohne PlayOnLinux
Die Änderungen werden in /var/log/laus/sichern.log dokumentiert.
sichern_POL
Sicherung auf den Server mit PlayOnLinux
Die Änderungen werden in /var/log/laus/sichern_POL.log dokumentiert.
sichern-n und sichern_POL-n
Der zusätzliche Parameter -n bei rsync bewirkt, dass nichts kopiert wird. Es wird nur angezeigt, was kopiert würde.
Die Ausgabe kann auch mit > (Dateiname) in eine Datei umgeleitet werden.
###7.2  am Server
Hier gibt es in /root die Dateien sichern-server.sh und sichern-server_POL.sh. Mit diesen wird praktisch der gesamte Server im Verzeichnis /DATEN/sicherung/(Datum und Zeit) gesichert:
/export/autoinstall (die Skripte) und /export/files in export.sq
/var/lib/tftpboot in tftpboot.sq (auskommentiert, nur bei Bedarf)
/var/lib/mysql in mysql.sq (auskommentiert, nur bei Bedarf)
Dazu Server-Konfigurationsdateien aus /etc (v.a. DHCP, DNS, Samba, Netzwerkeinstellungen)
Die Dateien *.sq sind Squashfs-Dateien. Dabei wird mit mksquashfs ein ganzer Verzeichnisbaum in eine Datei gepackt. Mit z.B.
	mount -o loop export.sq /mnt
wird dieser dann wieder in /mnt eingebunden, dann können mit mc alle oder einzelne Dateien wieder irgendwohin kopiert werden.
##8  Inspektion der Änderungen am Client
Wurde eine Datei im Home-Verzeichnis geändert, wird diese Änderung nicht im „originalen“ Home-Verzeichnis gespeichert, sondern in /nwboxuser-rw. In diesem Verzeichnis sieht man also alle Dateien, die geändert wurden.
Die Änderungen kann man sich sehr leicht mit mc ansehen:
In einem Fenster geht man nach /nwboxuser‑rw (bzw. dort in ein Unetrverzeichnis) und stellt den Cursor auf die fragliche Datei.
Im anderen Fenster stellt man den Cursor auf die entsprechende Datei in /opt/nwboxuser.
Nun kann man sich mit Strg-X, Strg-D die Änderungen - farblich hervorgehoben - anzeigen lassen.
