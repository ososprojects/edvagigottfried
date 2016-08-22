#! /bin/bash
#
## source system - functions
. /lib/init/vars.sh
. /lib/lsb/init-functions

# Shell variables sourced from 
# "LAUS calling client" from file /etc/default/laus-setup on clients filesystem
. /etc/default/laus-setup
### ENABLE_AUTOUPDATE="yes"
## Server hosting all LAUS - scripts:
### LAUS_SERVER="laus01"
## Rootpath,where LAUS - directory is stored:
### PATH_ON_LAUS_SERVER="/autoinstall"
## Directory, relativ to PATH_ON_LAUS_SERVER, where laus_server.sh - script is stored:
### LAUS_PATH="laus"
## Mountpoint on client, for Serverdirectory
### MOUNT_PATH_ON_CLIENT="/opt/autoinstall"
## Path, where updatelogfiles are written to:
### UPDATE_LOG_DIR="/var/log/laus"

# Updatescripts may not be executed on LAUS-SERVER!
if [ $(hostname) = ${LAUS_SERVER} ];
then
	log_action_begin_msg "Updatescript may not run on  laus - Server!"
	echo "Updatescript may not run on  laus - Server!"
	exit 7
fi

######################################################################################
################## Helper Function ###################################################
######################################################################################

# Function for executing all scripts in directory
function executeScripts {
	path=$1
	if [ -z ${path} ];
	then
		CLASSPATH="ALLCLASSES";
	else
		# replace / with .
		CLASSPATH="ALLCLASSES."${path//\//.};
	fi
	fileList=$(ls)
	for file in ${fileList}; 
	do
		# test, if file is executable and does not end with ~
		if [ -f ${file} -a -x ${file} -a ${file} = ${file%"~"} ];
		then
			# test, if script has already been executed and logged on this workstation
			if [ -f ${UPDATE_LOG_DIR}"/"${CLASSPATH}"."${file} ]
			then
				log_action_begin_msg "already executed --> "${CLASSPATH}"."${file}
				#echo "already executed --> "${CLASSPATH}"."${file}
			else
				log_action_begin_msg "running LAUS script --> "${CLASSPATH}"."${file}
				#echo "running LAUS script --> "${CLASSPATH}"."${file}
				"./"${file} ${startParameter}
				# if script has been executed, log it"
				if [ $? -eq 0 ];
				then
					cp ${file} ${UPDATE_LOG_DIR}"/"${CLASSPATH}"."${file}
				fi
			fi
		fi
	done
}


######################################################################################
################## S T A R T   O F   S C R I P T #####################################
######################################################################################

# set HOSTCLASSES variable from file hostsToClasses
# check like similar to tftp:
# for hostname r001pc12
# test following Strings:
# #1: r
# #2: r0
# #3: r00
# #4: r001
# #5: r001p
# #6: r001pc
# #7: r001pc1
# #8: r001pc12
#
# and collect all information in:
# HOSTCLASSES
#
# see: HOSTCLASSES=${HOSTCLASSES}" "$(grep ^${TESTSTRING}";" hostsToClasses | awk 'BEGIN { FS = ";" } { print $2 }')
#
# hostsToClasses in format:
# HOSTNAME:<List of Pathes>
#
# Example: for lines in hostsToClasses
#
# r001:UBUNTU1404 UBUNTU1404/GNOME R001
# r001pc50: BEAMER
# 
# => $HOSTCLASSES for PC with hostname r001xxxx: UBUNTU1404 UBUNTU1404/GNOME R001
# => $HOSTCLASSES for PC with hostname r001pc50: UBUNTU1404 UBUNTU1404/GNOME R001 BEAMER
#
HOSTNAME=$(hostname)
for ((length=1; length<=${#HOSTNAME}; length++)) 
do
	TESTSTRING=${HOSTNAME:0:length}
	HOSTCLASSES=${HOSTCLASSES}" "$(grep ^${TESTSTRING}":" hostsToClasses | awk 'BEGIN { FS = ":" } { print $2 }')
done

# souround List of hosts with () to cast to array
HOSTCLASSES=(${HOSTCLASSES})

log_action_begin_msg "LAUS START --------------------------------------" $(date)

#### get Startparameter: for example: start, stop, cron
startParameter=$1

# run scripts for all hosts <=> ALLCLASSES
cd scriptsForClasses
executeScripts

# run scripts for classes <=> pathes in directory scriptsForClasses
CURRENTRIR=$(pwd)
for hostclass in ${HOSTCLASSES[@]}; do
	if [ -d ${hostclass} ]; 
	then
		cd ${hostclass};
		executeScripts ${hostclass};
		cd ${CURRENTRIR};
	fi;
done

log_action_begin_msg "LAUS STOP ---------------------------------------" $(date)



