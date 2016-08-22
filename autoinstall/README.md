Linux - Autoinstall:

LAUS = L(inux) A(utomatic) U(pdate) S(ystem)

Introduction: 
LAUS is the german word for louse or cootie. 
LAUS is a small and easy system to manage groups of Linux-workstations. 
The idea is simple. 
When a workstation (LAUS-client) starts up, it connects to an special workstation (LAUS-server) and checks there for scripts. 
Initially it was written for SUSE-Linux, but this version is made for UBUNTU-Linux.

LAUS-client: 
Two files and the nfs-client package are necessary:
*	Configuration-file in: /etc/default/laus-setup
*	Startup-script in: /etc/init/laus-client.conf 
/etc/init/laus-client.conf connects via nfs to the LAUS-server and executes the laus-server.sh script.

LAUS-server: 
The LAUS-server hosts an nfs-share, which is located at /opt/autoinstall, but can also be located anywhere else. 
Two files and an nfs-server package are necessary:
*	'The' server-script in: /opt/autoinstall/laus/laus-server.sh 
*	Host to Classes file in: /opt/autoinstall/laus/hostToClasses 
and of course all your own scripts in the
*	OWN_SCRIPTS: /opt/autoinstall/laus/scriptsForClasses/"directory-tree. 
Then any LAUS-client connecting via "/etc/init/laus-client.conf" executes the script "/opt/autoinstall/laus/laus-server.sh". 
"laus-server.sh" checks in "/opt/autoinstall/laus/hostToClasses" whether a "part" of the hostname can be found and in which subdirectories of "/opt/autoinstall/laus/scriptsForClasses/" scripts shall be executed. 
In laus-server.sh the "part" of hostname is checked similar as the tftp-server does: 
for hostname r001pc12 the following 8 strings are tested if they can be found in "/opt/autoinstall/laus/hostToClasses" 
#1: r001pc12: 
#2: r001pc1: 
#3. r001pc: 
... 
#8: r: 

If one ore more have been found, all classes (directory-paths) are collected and all scripts in these paths are executed.

Example 1: (One hostname is assigned to directories, which are containing the scripts.)

The line r099pc04:UBUNTU1404 BEAMER VMS 
in 
/opt/autoinstall/laus/hostToClasses 
means: 
for workstation r099pc04 execute all executable scripts found in 
*	/opt/autoinstall/laus/scriptsForClasses/UBUNTU1404 
*	/opt/autoinstall/laus/scriptsForClasses/BEAMER 
*	/opt/autoinstall/laus/scriptsForClasses/VMS 

Example 2: (Similar hostnames are assigned to directories and subdirectories, which are containing the scripts.) 
The line 
r001:UBUNTU1404 VMS UPDATE UPDATE/R001 PRINTER/HP_LASER 
in 
/opt/autoinstall/laus/hostToClasses 
means: 
all workstations, whose hostname starts with r001 (f.E.: r001pc01, r001pc02, ...) 
execute all scripts which can be found in 
*	/opt/autoinstall/laus/scriptsForClasses/UBUNTU1404 
*	/opt/autoinstall/laus/scriptsForClasses/VMS 
*	/opt/autoinstall/laus/scriptsForClasses/UPDATE/ 
*	/opt/autoinstall/laus/scriptsForClasses/UPDATE/R001 
*	/opt/autoinstall/laus/scriptsForClasses/PRINTER/HP_LASER 


Technical details:
*	Order of script-execution: 
Scripts are executed in the same order as they appear in the file system. 
Classes are executed in the same order in which they appear in hostToClasses.

*	Logging - scripts running only once:
Executed scripts are logged in /var/log/laus with an easy syntax: 
all scripts start with ALLCLASSES and "/" is replaced with ".". 
For example:
*	autoinstall/scriptsForClasses/UBUNTU1404/020-installUbuntuDesktop.sh 
is logged as 
*	/var/log/laus/ALLCLASSES.UBUNTU1404.020-installUbuntuDesktop.sh 
When a script is logged, it will not be executed any more. 
So removing ALLCLASSES.UBUNTU1404.020-installUbuntuDesktop.sh in /var/log/laus means, that 020-installUbuntuDesktop.sh will be executed the next time when the LAUS-client starts.

